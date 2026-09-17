import 'package:flutter/material.dart';
import 'package:stringer/app/theme/app_colors.dart';
import 'package:stringer/app/theme/app_spacing.dart';
import 'package:stringer/app/theme/app_text_styles.dart';
import 'package:stringer/core/extensions/build_context_extensions.dart';

class SendRemindersBar extends StatelessWidget {
  final int selectedCount;
  final bool isSending;
  final VoidCallback? onSend;

  const SendRemindersBar({
    super.key,
    required this.selectedCount,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Text(
            context.l10n.selectedRecipientsLabel(selectedCount),
            style: AppTextStyles.bodyStrong,
          ),
          const Spacer(),
          if (isSending) ...[
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(context.l10n.sendingInProgressMessage),
          ] else
            ElevatedButton.icon(
              onPressed: selectedCount == 0 ? null : onSend,
              icon: const Icon(Icons.send_outlined, size: 18),
              label: Text(context.l10n.sendRemindersButton),
            ),
        ],
      ),
    );
  }
}
