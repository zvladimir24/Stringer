import 'package:flutter/material.dart';
import 'package:stringer/core/extensions/build_context_extensions.dart';

/// Shows a dialog for adding/editing a customer's reminder email subject
/// (naslov). Returns the trimmed value, or null if the user cancelled.
Future<String?> showNaslovEditDialog({
  required BuildContext context,
  String? existingValue,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _NaslovEditDialog(existingValue: existingValue),
  );
}

class _NaslovEditDialog extends StatefulWidget {
  final String? existingValue;

  const _NaslovEditDialog({this.existingValue});

  @override
  State<_NaslovEditDialog> createState() => _NaslovEditDialogState();
}

class _NaslovEditDialogState extends State<_NaslovEditDialog> {
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
      title: Text(context.l10n.naslovDialogTitle),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: context.l10n.naslovDialogLabel,
          hintText: context.l10n.naslovDialogHint,
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
