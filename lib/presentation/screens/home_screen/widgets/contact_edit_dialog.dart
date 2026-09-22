import 'package:flutter/material.dart';
import 'package:stringer/core/extensions/build_context_extensions.dart';
import 'package:stringer/domain/models/customer_contact.dart';

/// Shows a dialog for adding/editing a customer's email plus the optional
/// CC emails (komercijalista, direktor, menadžer) that should also receive
/// the reminder. Returns the saved [CustomerContact], or null if the user
/// cancelled.
Future<CustomerContact?> showContactEditDialog({
  required BuildContext context,
  required String pib,
  CustomerContact? existingContact,
}) {
  return showDialog<CustomerContact>(
    context: context,
    builder: (_) =>
        ContactEditDialog(pib: pib, existingContact: existingContact),
  );
}

class ContactEditDialog extends StatefulWidget {
  final String pib;
  final CustomerContact? existingContact;

  const ContactEditDialog({
    super.key,
    required this.pib,
    this.existingContact,
  });

  @override
  State<ContactEditDialog> createState() => _ContactEditDialogState();
}

class _ContactEditDialogState extends State<ContactEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _komercijalistaEmailController;
  late final TextEditingController _direktorEmailController;
  late final TextEditingController _menadzerEmailController;

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
      text: widget.existingContact?.email ?? '',
    );
    _komercijalistaEmailController = TextEditingController(
      text: widget.existingContact?.komercijalistaEmail ?? '',
    );
    _direktorEmailController = TextEditingController(
      text: widget.existingContact?.direktorEmail ?? '',
    );
    _menadzerEmailController = TextEditingController(
      text: widget.existingContact?.menadzerEmail ?? '',
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _komercijalistaEmailController.dispose();
    _direktorEmailController.dispose();
    _menadzerEmailController.dispose();
    super.dispose();
  }

  String? _validateOptionalEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (!_emailRegex.hasMatch(value.trim())) {
      return context.l10n.contactDialogInvalidEmail;
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      CustomerContact(
        pib: widget.pib,
        email: _emailController.text.trim(),
        komercijalista: widget.existingContact?.komercijalista ?? '',
        naslov: widget.existingContact?.naslov ?? '',
        komercijalistaEmail: _komercijalistaEmailController.text.trim(),
        direktorEmail: _direktorEmailController.text.trim(),
        menadzerEmail: _menadzerEmailController.text.trim(),
        lastEmailSentAt: widget.existingContact?.lastEmailSentAt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.contactDialogTitle),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: context.l10n.contactDialogEmailLabel,
                hintText: context.l10n.contactDialogEmailHint,
              ),
              validator: (value) {
                if (value == null || !_emailRegex.hasMatch(value.trim())) {
                  return context.l10n.contactDialogInvalidEmail;
                }
                return null;
              },
            ),
            TextFormField(
              controller: _komercijalistaEmailController,
              decoration: InputDecoration(
                labelText: context.l10n.contactDialogKomercijalistaEmailLabel,
                hintText: context.l10n.contactDialogEmailHint,
              ),
              validator: _validateOptionalEmail,
            ),
            TextFormField(
              controller: _direktorEmailController,
              decoration: InputDecoration(
                labelText: context.l10n.contactDialogDirektorEmailLabel,
                hintText: context.l10n.contactDialogEmailHint,
              ),
              validator: _validateOptionalEmail,
            ),
            TextFormField(
              controller: _menadzerEmailController,
              decoration: InputDecoration(
                labelText: context.l10n.contactDialogMenadzerEmailLabel,
                hintText: context.l10n.contactDialogEmailHint,
              ),
              validator: _validateOptionalEmail,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.contactDialogCancelButton),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(context.l10n.contactDialogSaveButton),
        ),
      ],
    );
  }
}
