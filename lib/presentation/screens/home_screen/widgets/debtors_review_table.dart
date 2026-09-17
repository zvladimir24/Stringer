import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stringer/app/theme/app_colors.dart';
import 'package:stringer/app/theme/app_text_styles.dart';
import 'package:stringer/core/error/failure.dart';
import 'package:stringer/core/extensions/build_context_extensions.dart';
import 'package:stringer/domain/models/customer_contact.dart';
import 'package:stringer/domain/models/debtor.dart';

class DebtorsReviewTable extends StatelessWidget {
  final List<Debtor> debtors;
  final Map<String, CustomerContact> contactsByPib;
  final Set<String> selectedPibs;
  final Map<String, Failure?> sendResults;
  final ValueChanged<String> onToggleSelection;
  final ValueChanged<Debtor> onEditContact;
  final ValueChanged<Debtor> onEditKomercijalista;

  const DebtorsReviewTable({
    super.key,
    required this.debtors,
    required this.contactsByPib,
    required this.selectedPibs,
    required this.sendResults,
    required this.onToggleSelection,
    required this.onEditContact,
    required this.onEditKomercijalista,
  });

  @override
  Widget build(BuildContext context) {
    final amountFormat = NumberFormat.decimalPatternDigits(
      locale: 'sr_RS',
      decimalDigits: 2,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.background),
          columns: [
            const DataColumn(label: SizedBox.shrink()),
            DataColumn(
              label: Text(
                context.l10n.tableColumnCode,
                style: AppTextStyles.bodyStrong,
              ),
            ),
            DataColumn(
              label: Text(
                context.l10n.tableColumnCompany,
                style: AppTextStyles.bodyStrong,
              ),
            ),
            DataColumn(
              label: Text(
                context.l10n.tableColumnPib,
                style: AppTextStyles.bodyStrong,
              ),
            ),
            DataColumn(
              numeric: true,
              label: Text(
                context.l10n.tableColumnTotalDebt,
                style: AppTextStyles.bodyStrong,
              ),
            ),
            DataColumn(
              numeric: true,
              label: Text(
                context.l10n.tableColumnCurrentDebt,
                style: AppTextStyles.bodyStrong,
              ),
            ),
            DataColumn(
              numeric: true,
              label: Text(
                context.l10n.tableColumnTotalOverdue,
                style: AppTextStyles.bodyStrong,
              ),
            ),
            DataColumn(
              numeric: true,
              label: Text(
                context.l10n.tableColumnOverdue7,
                style: AppTextStyles.bodyStrong,
              ),
            ),
            DataColumn(
              numeric: true,
              label: Text(
                context.l10n.tableColumnOverdue15,
                style: AppTextStyles.bodyStrong,
              ),
            ),
            DataColumn(
              numeric: true,
              label: Text(
                context.l10n.tableColumnOverdue30,
                style: AppTextStyles.bodyStrong,
              ),
            ),
            DataColumn(
              numeric: true,
              label: Text(
                context.l10n.tableColumnOverdue60,
                style: AppTextStyles.bodyStrong,
              ),
            ),
            DataColumn(
              numeric: true,
              label: Text(
                context.l10n.tableColumnOverdueOver60,
                style: AppTextStyles.bodyStrong,
              ),
            ),
            DataColumn(
              label: Text(
                context.l10n.tableColumnEmail,
                style: AppTextStyles.bodyStrong,
              ),
            ),
            DataColumn(
              label: Text(
                context.l10n.tableColumnKomercijalista,
                style: AppTextStyles.bodyStrong,
              ),
            ),
            DataColumn(
              label: Text(
                context.l10n.tableColumnLastEmailSent,
                style: AppTextStyles.bodyStrong,
              ),
            ),
            DataColumn(
              label: Text(
                context.l10n.tableColumnStatus,
                style: AppTextStyles.bodyStrong,
              ),
            ),
          ],
          rows: debtors.map((debtor) {
            final contact = contactsByPib[debtor.pib];
            final isSelected = selectedPibs.contains(debtor.pib);
            final hasSendResult = sendResults.containsKey(debtor.pib);
            final sendFailure = sendResults[debtor.pib];
            final hasOverdue = debtor.totalOverdue > 0;

            String amount(double value) => amountFormat.format(value);

            return DataRow(
              cells: [
                DataCell(
                  Checkbox(
                    value: isSelected,
                    onChanged: (contact == null || contact.email.isEmpty)
                        ? null
                        : (_) => onToggleSelection(debtor.pib),
                  ),
                ),
                DataCell(Text(debtor.code)),
                DataCell(Text(debtor.companyName)),
                DataCell(Text(debtor.pib)),
                DataCell(Text(amount(debtor.totalDebt))),
                DataCell(Text(amount(debtor.currentDebt))),
                DataCell(
                  Text(
                    amount(debtor.totalOverdue),
                    style: AppTextStyles.body.copyWith(
                      color: hasOverdue
                          ? AppColors.error
                          : AppColors.textPrimary,
                      fontWeight: hasOverdue
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                ),
                DataCell(Text(amount(debtor.overdueUpTo7Days))),
                DataCell(Text(amount(debtor.overdueUpTo15Days))),
                DataCell(Text(amount(debtor.overdueUpTo30Days))),
                DataCell(Text(amount(debtor.overdueUpTo60Days))),
                DataCell(Text(amount(debtor.overdueOver60Days))),
                DataCell(
                  _EmailCell(
                    contact: contact,
                    onTap: () => onEditContact(debtor),
                  ),
                ),
                DataCell(
                  _KomercijalistaCell(
                    komercijalista: contact?.komercijalista,
                    onTap: () => onEditKomercijalista(debtor),
                  ),
                ),
                DataCell(_LastEmailSentCell(contact: contact)),
                DataCell(
                  _StatusCell(hasResult: hasSendResult, failure: sendFailure),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _EmailCell extends StatelessWidget {
  final CustomerContact? contact;
  final VoidCallback onTap;

  const _EmailCell({required this.contact, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (contact == null || contact!.email.isEmpty) {
      return OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.add, size: 16),
        label: Text(context.l10n.addEmailButton),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(contact!.email),
        IconButton(
          tooltip: context.l10n.editEmailTooltip,
          icon: const Icon(Icons.edit_outlined, size: 16),
          onPressed: onTap,
        ),
      ],
    );
  }
}

class _KomercijalistaCell extends StatelessWidget {
  final String? komercijalista;
  final VoidCallback onTap;

  const _KomercijalistaCell({required this.komercijalista, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (komercijalista == null || komercijalista!.isEmpty) {
      return OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.add, size: 16),
        label: Text(context.l10n.addKomercijalistaButton),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(komercijalista!),
        IconButton(
          tooltip: context.l10n.editKomercijalistaTooltip,
          icon: const Icon(Icons.edit_outlined, size: 16),
          onPressed: onTap,
        ),
      ],
    );
  }
}

class _LastEmailSentCell extends StatelessWidget {
  final CustomerContact? contact;

  const _LastEmailSentCell({required this.contact});

  @override
  Widget build(BuildContext context) {
    final lastSentAt = contact?.lastEmailSentAt;
    if (lastSentAt == null) {
      return Text(
        context.l10n.lastEmailSentNeverLabel,
        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
      );
    }

    return Text(DateFormat('dd.MM.yyyy HH:mm').format(lastSentAt));
  }
}

class _StatusCell extends StatelessWidget {
  final bool hasResult;
  final Failure? failure;

  const _StatusCell({required this.hasResult, required this.failure});

  @override
  Widget build(BuildContext context) {
    if (!hasResult) return const SizedBox.shrink();

    if (failure == null) {
      return Tooltip(
        message: context.l10n.sendResultSuccessTooltip,
        child: const Icon(
          Icons.check_circle,
          color: AppColors.success,
          size: 18,
        ),
      );
    }

    final shortMessage = failure!.type == FailureType.smtpNotConfigured
        ? context.l10n.sendResultSmtpNotConfiguredTooltip
        : context.l10n.sendResultFailedTooltip;
    final message = failure!.details == null
        ? shortMessage
        : '$shortMessage\n${failure!.details}';

    return Tooltip(
      message: message,
      child: const Icon(Icons.error, color: AppColors.error, size: 18),
    );
  }
}
