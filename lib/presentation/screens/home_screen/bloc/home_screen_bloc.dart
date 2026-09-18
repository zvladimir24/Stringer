import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:stringer/core/error/app_exception.dart';
import 'package:stringer/core/error/failure.dart';
import 'package:stringer/domain/contacts/get_contacts_usecase.dart';
import 'package:stringer/domain/contacts/save_contact_usecase.dart';
import 'package:stringer/domain/email/send_payment_reminder_usecase.dart';
import 'package:stringer/domain/home_screen/import_debtors_usecase.dart';
import 'package:stringer/domain/models/customer_contact.dart';
import 'package:stringer/domain/models/smtp_settings.dart';
import 'package:stringer/domain/settings/get_smtp_settings_usecase.dart';
import 'package:stringer/domain/settings/save_smtp_settings_usecase.dart';

import 'home_screen_event.dart';
import 'home_screen_state.dart';

@injectable
class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final ImportDebtorsUseCase _importDebtorsUseCase;
  final GetContactsUseCase _getContactsUseCase;
  final SaveContactUseCase _saveContactUseCase;
  final SendPaymentReminderUseCase _sendPaymentReminderUseCase;
  final GetSmtpSettingsUseCase _getSmtpSettingsUseCase;
  final SaveSmtpSettingsUseCase _saveSmtpSettingsUseCase;

  HomeScreenBloc(
    this._importDebtorsUseCase,
    this._getContactsUseCase,
    this._saveContactUseCase,
    this._sendPaymentReminderUseCase,
    this._getSmtpSettingsUseCase,
    this._saveSmtpSettingsUseCase,
  ) : super(const HomeScreenInitial()) {
    on<HomeScreenExcelFileSelected>(_onExcelFileSelected);
    on<HomeScreenFileCleared>(_onFileCleared);
    on<HomeScreenContactSaved>(_onContactSaved);
    on<HomeScreenRecipientSelectionToggled>(_onRecipientSelectionToggled);
    on<HomeScreenSendRemindersRequested>(_onSendRemindersRequested);
    on<HomeScreenEmailSubjectChanged>(_onEmailSubjectChanged);
  }

  Future<void> _onExcelFileSelected(
    HomeScreenExcelFileSelected event,
    Emitter<HomeScreenState> emit,
  ) async {
    emit(const HomeScreenLoading());

    try {
      final debtors = await _importDebtorsUseCase(event.filePath);

      if (debtors.isEmpty) {
        emit(HomeScreenEmpty(fileName: event.fileName));
        return;
      }

      final contacts = await _getContactsUseCase();
      final contactsByPib = {for (final c in contacts) c.pib: c};
      final smtpSettings = await _getSmtpSettingsUseCase();

      // Customers who owe something float to the top instead of being
      // mixed in with the rest of the list.
      final sortedDebtors = [...debtors]
        ..sort((a, b) {
          if (a.hasOutstandingDebt != b.hasOutstandingDebt) {
            return a.hasOutstandingDebt ? -1 : 1;
          }
          return b.totalOverdue.compareTo(a.totalOverdue);
        });

      // Pre-select customers who owe something and already have an email
      // on file; the user can still uncheck individual rows.
      final defaultSelection = sortedDebtors
          .where(
            (d) =>
                d.hasOutstandingDebt &&
                (contactsByPib[d.pib]?.email.isNotEmpty ?? false),
          )
          .map((d) => d.pib)
          .toSet();

      emit(
        HomeScreenLoaded(
          fileName: event.fileName,
          debtors: sortedDebtors,
          contactsByPib: contactsByPib,
          selectedPibs: defaultSelection,
          emailSubject:
              smtpSettings?.emailSubject ?? SmtpSettings.defaultEmailSubject,
        ),
      );
    } on AppException catch (exception) {
      emit(HomeScreenError(failureType: exception.failure.type));
    } catch (_) {
      emit(const HomeScreenError(failureType: FailureType.fileReadError));
    }
  }

  void _onFileCleared(
    HomeScreenFileCleared event,
    Emitter<HomeScreenState> emit,
  ) {
    emit(const HomeScreenInitial());
  }

  Future<void> _onContactSaved(
    HomeScreenContactSaved event,
    Emitter<HomeScreenState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeScreenLoaded) return;

    await _saveContactUseCase(event.contact);

    final updatedContacts = Map<String, CustomerContact>.from(
      currentState.contactsByPib,
    )..[event.contact.pib] = event.contact;

    final debtor = currentState.debtors.firstWhere(
      (d) => d.pib == event.contact.pib,
    );
    final updatedSelection = Set<String>.from(currentState.selectedPibs);
    if (debtor.hasOutstandingDebt && event.contact.email.isNotEmpty) {
      updatedSelection.add(event.contact.pib);
    }

    emit(
      currentState.copyWith(
        contactsByPib: updatedContacts,
        selectedPibs: updatedSelection,
      ),
    );
  }

  void _onRecipientSelectionToggled(
    HomeScreenRecipientSelectionToggled event,
    Emitter<HomeScreenState> emit,
  ) {
    final currentState = state;
    if (currentState is! HomeScreenLoaded) return;

    final updatedSelection = Set<String>.from(currentState.selectedPibs);
    if (!updatedSelection.remove(event.pib)) {
      updatedSelection.add(event.pib);
    }

    emit(currentState.copyWith(selectedPibs: updatedSelection));
  }

  Future<void> _onSendRemindersRequested(
    HomeScreenSendRemindersRequested event,
    Emitter<HomeScreenState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeScreenLoaded ||
        currentState.selectedPibs.isEmpty) {
      return;
    }

    emit(currentState.copyWith(isSending: true));

    final results = <String, Failure?>{};
    final updatedContacts = Map<String, CustomerContact>.from(
      currentState.contactsByPib,
    );
    for (final pib in currentState.selectedPibs) {
      final debtor = currentState.debtors.firstWhere((d) => d.pib == pib);
      final contact = currentState.contactsByPib[pib];
      if (contact == null || contact.email.isEmpty) continue;

      try {
        await _sendPaymentReminderUseCase(debtor: debtor, contact: contact);
        results[pib] = null;

        final sentContact = contact.copyWith(lastEmailSentAt: DateTime.now());
        await _saveContactUseCase(sentContact);
        updatedContacts[pib] = sentContact;
      } on AppException catch (exception) {
        results[pib] = exception.failure;
      } catch (e) {
        results[pib] = Failure(FailureType.sendFailed, details: e.toString());
      }
    }

    emit(
      currentState.copyWith(
        isSending: false,
        contactsByPib: updatedContacts,
        sendResults: results,
        selectedPibs: const {},
      ),
    );
  }

  Future<void> _onEmailSubjectChanged(
    HomeScreenEmailSubjectChanged event,
    Emitter<HomeScreenState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeScreenLoaded) return;

    emit(currentState.copyWith(emailSubject: event.emailSubject));

    // Persist it so it's remembered next time a file is loaded, same as
    // contact emails and komercijalista.
    final existingSettings = await _getSmtpSettingsUseCase();
    if (existingSettings != null) {
      await _saveSmtpSettingsUseCase(
        existingSettings.copyWith(emailSubject: event.emailSubject),
      );
    }
  }
}
