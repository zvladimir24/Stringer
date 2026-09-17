import 'package:flutter/material.dart';
import 'package:stringer/core/extensions/build_context_extensions.dart';
import 'package:stringer/domain/models/customer_contact.dart';

/// Shows a dialog for adding/editing a customer's email. Returns the saved
/// [CustomerContact], or null if the user cancelled.
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
  late final TextEditingController _komercijalistaController;

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
      text: widget.existingContact?.email ?? '',
    );
    _komercijalistaController = TextEditingController(
      text: widget.existingContact?.komercijalista ?? '',
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _komercijalistaController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      CustomerContact(
        pib: widget.pib,
        email: _emailController.text.trim(),
        komercijalista: _komercijalistaController.text.trim(),
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
              controller: _komercijalistaController,
              decoration: InputDecoration(
                labelText: context.l10n.contactDialogKomercijalistaLabel,
                hintText: context.l10n.contactDialogKomercijalistaHint,
              ),
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
