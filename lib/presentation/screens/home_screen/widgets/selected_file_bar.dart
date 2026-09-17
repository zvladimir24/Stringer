import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stringer/app/theme/app_colors.dart';
import 'package:stringer/app/theme/app_spacing.dart';
import 'package:stringer/app/theme/app_text_styles.dart';
import 'package:stringer/core/extensions/build_context_extensions.dart';

import '../bloc/home_screen_bloc.dart';
import '../bloc/home_screen_event.dart';

class SelectedFileBar extends StatelessWidget {
  final String fileName;
  final VoidCallback onChangeFile;
  final int? recordCount;

  const SelectedFileBar({
    super.key,
    required this.fileName,
    required this.onChangeFile,
    this.recordCount,
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
            Icons.description_outlined,
            size: 18,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              context.l10n.selectedFileLabel(fileName),
              style: AppTextStyles.bodyStrong,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (recordCount != null) ...[
            Text(
              context.l10n.totalRecordsLabel(recordCount!),
              style: AppTextStyles.caption,
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          OutlinedButton(
            onPressed: onChangeFile,
            child: Text(context.l10n.changeExcelFileButton),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            tooltip: context.l10n.clearFileButton,
            icon: const Icon(Icons.close),
            onPressed: () =>
                context.read<HomeScreenBloc>().add(const HomeScreenFileCleared()),
          ),
        ],
      ),
    );
  }
}
