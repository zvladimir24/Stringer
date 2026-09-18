import 'package:flutter/material.dart';
import 'package:stringer/app/theme/app_colors.dart';
import 'package:stringer/app/theme/app_spacing.dart';
import 'package:stringer/app/theme/app_text_styles.dart';
import 'package:stringer/core/extensions/build_context_extensions.dart';

class EmailSubjectBar extends StatelessWidget {
  final String emailSubject;
  final VoidCallback onEdit;

  const EmailSubjectBar({
    super.key,
    required this.emailSubject,
    required this.onEdit,
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
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.subject_outlined,
            size: 18,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${context.l10n.settingsEmailSubjectLabel}: ',
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          Expanded(
            child: Text(
              emailSubject,
              style: AppTextStyles.bodyStrong,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            tooltip: context.l10n.editEmailSubjectTooltip,
            icon: const Icon(Icons.edit_outlined, size: 18),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}
