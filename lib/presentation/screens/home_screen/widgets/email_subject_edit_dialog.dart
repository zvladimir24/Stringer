import 'package:flutter/material.dart';
import 'package:stringer/core/extensions/build_context_extensions.dart';

/// Shows a dialog for editing the reminder email's subject line. Returns
/// the trimmed value, or null if the user cancelled.
Future<String?> showEmailSubjectEditDialog({
  required BuildContext context,
  required String existingValue,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _EmailSubjectEditDialog(existingValue: existingValue),
  );
}

class _EmailSubjectEditDialog extends StatefulWidget {
  final String existingValue;

  const _EmailSubjectEditDialog({required this.existingValue});

  @override
  State<_EmailSubjectEditDialog> createState() =>
      _EmailSubjectEditDialogState();
}

class _EmailSubjectEditDialogState extends State<_EmailSubjectEditDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.existingValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.settingsEmailSubjectLabel),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: context.l10n.settingsEmailSubjectLabel,
          hintText: context.l10n.settingsEmailSubjectHint,
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
