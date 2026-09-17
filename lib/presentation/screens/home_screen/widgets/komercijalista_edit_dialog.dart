import 'package:flutter/material.dart';
import 'package:stringer/core/extensions/build_context_extensions.dart';

/// Shows a dialog for adding/editing a customer's assigned sales rep
/// (komercijalista). Returns the trimmed value, or null if the user
/// cancelled.
Future<String?> showKomercijalistaEditDialog({
  required BuildContext context,
  String? existingValue,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _KomercijalistaEditDialog(existingValue: existingValue),
  );
}

class _KomercijalistaEditDialog extends StatefulWidget {
  final String? existingValue;

  const _KomercijalistaEditDialog({this.existingValue});

  @override
  State<_KomercijalistaEditDialog> createState() =>
      _KomercijalistaEditDialogState();
}

class _KomercijalistaEditDialogState
    extends State<_KomercijalistaEditDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.existingValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.komercijalistaDialogTitle),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: context.l10n.contactDialogKomercijalistaLabel,
          hintText: context.l10n.contactDialogKomercijalistaHint,
        ),
        onSubmitted: (_) => _save(),
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
