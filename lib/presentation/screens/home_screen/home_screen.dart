import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stringer/app/di/injection.dart';
import 'package:stringer/app/theme/app_spacing.dart';
import 'package:stringer/core/error/failure.dart';
import 'package:stringer/core/extensions/build_context_extensions.dart';
import 'package:stringer/domain/models/customer_contact.dart';
import 'package:stringer/domain/models/debtor.dart';
import 'package:stringer/presentation/screens/settings_screen/settings_screen.dart';

import '../../widgets/app_state_message.dart';
import 'bloc/home_screen_bloc.dart';
import 'bloc/home_screen_event.dart';
import 'bloc/home_screen_state.dart';
import 'widgets/contact_edit_dialog.dart';
import 'widgets/debtors_review_table.dart';
import 'widgets/komercijalista_edit_dialog.dart';
import 'widgets/selected_file_bar.dart';
import 'widgets/send_reminders_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeScreenBloc>(),
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatelessWidget {
  const _HomeScreenView();

  Future<void> _pickExcelFile(BuildContext context) async {
    final pickedFile = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    final path = pickedFile?.path;
    if (path == null) return;

    if (!context.mounted) return;
    context.read<HomeScreenBloc>().add(
      HomeScreenExcelFileSelected(filePath: path, fileName: pickedFile!.name),
    );
  }

  Future<void> _editContact(
    BuildContext context,
    Debtor debtor,
    CustomerContact? existingContact,
  ) async {
    final bloc = context.read<HomeScreenBloc>();
    final contact = await showContactEditDialog(
      context: context,
      pib: debtor.pib,
      existingContact: existingContact,
    );

    if (contact != null) {
      bloc.add(HomeScreenContactSaved(contact));
    }
  }

  Future<void> _editKomercijalista(
    BuildContext context,
    Debtor debtor,
    CustomerContact? existingContact,
  ) async {
    final bloc = context.read<HomeScreenBloc>();
    final komercijalista = await showKomercijalistaEditDialog(
      context: context,
      existingValue: existingContact?.komercijalista,
    );

    if (komercijalista == null) return;

    final updatedContact =
        existingContact?.copyWith(komercijalista: komercijalista) ??
        CustomerContact(
          pib: debtor.pib,
          email: '',
          komercijalista: komercijalista,
        );
    bloc.add(HomeScreenContactSaved(updatedContact));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.homeScreenTitle),
        actions: [
          IconButton(
            tooltip: context.l10n.settingsIconTooltip,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: BlocBuilder<HomeScreenBloc, HomeScreenState>(
        builder: (context, state) {
          return switch (state) {
            HomeScreenInitial() => AppStateMessage(
              icon: Icons.upload_file_outlined,
              title: context.l10n.noFileSelectedTitle,
              message: context.l10n.noFileSelectedMessage,
              actionLabel: context.l10n.selectExcelFileButton,
              onAction: () => _pickExcelFile(context),
            ),
            HomeScreenLoading() => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: AppSpacing.md),
                  Text(context.l10n.loadingMessage),
                ],
              ),
            ),
            HomeScreenEmpty(fileName: final fileName) => Column(
              children: [
                SelectedFileBar(
                  fileName: fileName,
                  onChangeFile: () => _pickExcelFile(context),
                ),
                Expanded(
                  child: AppStateMessage(
                    icon: Icons.inbox_outlined,
                    title: context.l10n.emptyStateTitle,
                    message: context.l10n.emptyStateMessage,
                  ),
                ),
              ],
            ),
            HomeScreenError(failureType: final failureType) => AppStateMessage(
              icon: Icons.error_outline,
              iconColor: Theme.of(context).colorScheme.error,
              title: _errorTitle(context, failureType),
              message: _errorMessage(context, failureType),
              actionLabel: context.l10n.retryButton,
              onAction: () => _pickExcelFile(context),
            ),
            HomeScreenLoaded(
              fileName: final fileName,
              debtors: final debtors,
              contactsByPib: final contactsByPib,
              selectedPibs: final selectedPibs,
              isSending: final isSending,
              sendResults: final sendResults,
            ) =>
              Column(
                children: [
                  SelectedFileBar(
                    fileName: fileName,
                    recordCount: debtors.length,
                    onChangeFile: () => _pickExcelFile(context),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: DebtorsReviewTable(
                        debtors: debtors,
                        contactsByPib: contactsByPib,
                        selectedPibs: selectedPibs,
                        sendResults: sendResults,
                        onToggleSelection: (pib) => context
                            .read<HomeScreenBloc>()
                            .add(HomeScreenRecipientSelectionToggled(pib)),
                        onEditContact: (debtor) => _editContact(
                          context,
                          debtor,
                          contactsByPib[debtor.pib],
                        ),
                        onEditKomercijalista: (debtor) => _editKomercijalista(
                          context,
                          debtor,
                          contactsByPib[debtor.pib],
                        ),
                      ),
                    ),
                  ),
                  SendRemindersBar(
                    selectedCount: selectedPibs.length,
                    isSending: isSending,
                    onSend: () => context.read<HomeScreenBloc>().add(
                      const HomeScreenSendRemindersRequested(),
                    ),
                  ),
                ],
              ),
          };
        },
      ),
    );
  }

  String _errorTitle(BuildContext context, FailureType type) {
    return switch (type) {
      FailureType.invalidFileFormat =>
        context.l10n.errorInvalidFileFormatTitle,
      FailureType.missingColumns => context.l10n.errorMissingColumnsTitle,
      FailureType.fileReadError ||
      FailureType.smtpNotConfigured ||
      FailureType.sendFailed => context.l10n.errorReadingFileTitle,
    };
  }

  String _errorMessage(BuildContext context, FailureType type) {
    return switch (type) {
      FailureType.invalidFileFormat =>
        context.l10n.errorInvalidFileFormatMessage,
      FailureType.missingColumns => context.l10n.errorMissingColumnsMessage,
      FailureType.fileReadError ||
      FailureType.smtpNotConfigured ||
      FailureType.sendFailed => context.l10n.errorReadingFileMessage,
    };
  }
}
