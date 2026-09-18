import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stringer/app/di/injection.dart';
import 'package:stringer/app/theme/app_spacing.dart';
import 'package:stringer/app/theme/app_text_styles.dart';
import 'package:stringer/core/extensions/build_context_extensions.dart';
import 'package:stringer/domain/models/smtp_settings.dart';

import 'bloc/settings_bloc.dart';
import 'bloc/settings_event.dart';
import 'bloc/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsBloc>()..add(const SettingsStarted()),
      child: const _SettingsScreenView(),
    );
  }
}

class _SettingsScreenView extends StatefulWidget {
  const _SettingsScreenView();

  @override
  State<_SettingsScreenView> createState() => _SettingsScreenViewState();
}

class _SettingsScreenViewState extends State<_SettingsScreenView> {
  final _formKey = GlobalKey<FormState>();
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _senderNameController = TextEditingController();
  final _senderEmailController = TextEditingController();
  final _footerController = TextEditingController();
  // Off by default: Gmail/Google Workspace (the expected provider) uses
  // STARTTLS on port 587, not a direct SSL connection.
  bool _useSsl = false;
  bool _initialized = false;

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _senderNameController.dispose();
    _senderEmailController.dispose();
    _footerController.dispose();
    super.dispose();
  }

  void _syncControllers(SmtpSettings? settings) {
    if (_initialized) return;
    _initialized = true;

    if (settings == null) {
      // No settings saved yet - default to Gmail/Google Workspace (the
      // expected provider) so there's less to fill in.
      _hostController.text = 'smtp.gmail.com';
      _portController.text = '587';
      return;
    }

    _hostController.text = settings.host;
    _portController.text = settings.port.toString();
    _usernameController.text = settings.username;
    _passwordController.text = settings.password;
    _senderNameController.text = settings.senderName;
    _senderEmailController.text = settings.senderEmail;
    _footerController.text = settings.footerText;
    _useSsl = settings.useSsl;
  }

  void _save(BuildContext context, SmtpSettings? existingSettings) {
    if (!_formKey.currentState!.validate()) return;

    final settings = SmtpSettings(
      host: _hostController.text.trim(),
      port: int.parse(_portController.text.trim()),
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      senderName: _senderNameController.text.trim(),
      senderEmail: _senderEmailController.text.trim(),
      useSsl: _useSsl,
      footerText: _footerController.text,
      // The email subject is set from the home screen when a file is
      // loaded, not here - preserve whatever is already stored.
      emailSubject:
          existingSettings?.emailSubject ?? SmtpSettings.defaultEmailSubject,
    );

    context.read<SettingsBloc>().add(SettingsSaveRequested(settings));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsScreenTitle)),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsReady && state.justSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.settingsSavedMessage)),
            );
          }
        },
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final readyState = state as SettingsReady;
          _syncControllers(readyState.settings);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      context.l10n.settingsSmtpSectionTitle,
                      style: AppTextStyles.subtitle,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _requiredField(
                      context,
                      _hostController,
                      context.l10n.settingsHostLabel,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _requiredField(
                      context,
                      _portController,
                      context.l10n.settingsPortLabel,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context.l10n.settingsValidationRequired;
                        }
                        if (int.tryParse(value.trim()) == null) {
                          return context.l10n.settingsValidationInvalidPort;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _requiredField(
                      context,
                      _usernameController,
                      context.l10n.settingsUsernameLabel,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: context.l10n.settingsPasswordLabel,
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? context.l10n.settingsValidationRequired
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _requiredField(
                      context,
                      _senderNameController,
                      context.l10n.settingsSenderNameLabel,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _requiredField(
                      context,
                      _senderEmailController,
                      context.l10n.settingsSenderEmailLabel,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(context.l10n.settingsUseSslLabel),
                      value: _useSsl,
                      onChanged: (value) => setState(() => _useSsl = value),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _footerController,
                      minLines: 2,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: context.l10n.settingsFooterLabel,
                        hintText: context.l10n.settingsFooterHint,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton(
                      onPressed: readyState.isSaving
                          ? null
                          : () => _save(context, readyState.settings),
                      child: readyState.isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(context.l10n.settingsSaveButton),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _requiredField(
    BuildContext context,
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
      validator:
          validator ??
          (value) => (value == null || value.trim().isEmpty)
              ? context.l10n.settingsValidationRequired
              : null,
    );
  }
}
