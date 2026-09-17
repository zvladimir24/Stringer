import 'package:stringer/domain/models/debtor.dart';

class DebtorDto {
  final String code;
  final String companyName;
  final String pib;
  final String currency;
  final String totalDebtRaw;
  final String currentDebtRaw;
  final String overdueUpTo7DaysRaw;
  final String overdueUpTo15DaysRaw;
  final String overdueUpTo30DaysRaw;
  final String overdueUpTo60DaysRaw;
  final String overdueOver60DaysRaw;

  const DebtorDto({
    required this.code,
    required this.companyName,
    required this.pib,
    required this.currency,
    required this.totalDebtRaw,
    required this.currentDebtRaw,
    required this.overdueUpTo7DaysRaw,
    required this.overdueUpTo15DaysRaw,
    required this.overdueUpTo30DaysRaw,
    required this.overdueUpTo60DaysRaw,
    required this.overdueOver60DaysRaw,
  });
}

extension DebtorDtoMapper on DebtorDto {
  Debtor toDomain() {
    return Debtor(
      code: code,
      companyName: companyName,
      pib: pib,
      currency: currency,
      totalDebt: _decimalOrZero(totalDebtRaw),
      currentDebt: _decimalOrZero(currentDebtRaw),
      overdueUpTo7Days: _decimalOrZero(overdueUpTo7DaysRaw),
      overdueUpTo15Days: _decimalOrZero(overdueUpTo15DaysRaw),
      overdueUpTo30Days: _decimalOrZero(overdueUpTo30DaysRaw),
      overdueUpTo60Days: _decimalOrZero(overdueUpTo60DaysRaw),
      overdueOver60Days: _decimalOrZero(overdueOver60DaysRaw),
    );
  }

  /// Every numeric cell here (totals and aging buckets alike) is
  /// legitimately blank when it doesn't apply to a given customer, so a
  /// blank cell means 0, not a parse failure.
  double _decimalOrZero(String raw) {
    return _parseDecimal(raw) ?? 0;
  }

  /// Accepts plain numeric text (e.g. "1500.5", produced by numeric excel
  /// cells) as well as Serbian-formatted text such as "1.500,50".
  double? _parseDecimal(String raw) {
    final cleaned = raw.trim();
    if (cleaned.isEmpty) return null;

    final hasComma = cleaned.contains(',');
    final hasDot = cleaned.contains('.');

    if (hasComma && hasDot) {
      return double.tryParse(cleaned.replaceAll('.', '').replaceAll(',', '.'));
    }
    if (hasComma) {
      return double.tryParse(cleaned.replaceAll(',', '.'));
    }
    return double.tryParse(cleaned);
  }
}
