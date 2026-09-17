class Debtor {
  final String code;
  final String companyName;
  final String pib;
  final String currency;
  final double totalDebt;
  final double currentDebt;
  final double overdueUpTo7Days;
  final double overdueUpTo15Days;
  final double overdueUpTo30Days;
  final double overdueUpTo60Days;
  final double overdueOver60Days;

  const Debtor({
    required this.code,
    required this.companyName,
    required this.pib,
    required this.currency,
    required this.totalDebt,
    required this.currentDebt,
    required this.overdueUpTo7Days,
    required this.overdueUpTo15Days,
    required this.overdueUpTo30Days,
    required this.overdueUpTo60Days,
    required this.overdueOver60Days,
  });

  double get totalOverdue => totalDebt - currentDebt;

  /// Provisional reminder-eligibility rule: a customer owes something at
  /// all (per "Ukupan dug"). This is expected to get more specific later
  /// (e.g. only once actually overdue) once that logic is decided.
  bool get hasOutstandingDebt => totalDebt > 0;
}
