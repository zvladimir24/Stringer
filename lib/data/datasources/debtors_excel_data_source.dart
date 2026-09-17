import 'dart:io';

import 'package:excel/excel.dart' as xlsx;
import 'package:injectable/injectable.dart';
import 'package:stringer/core/error/app_exception.dart';
import 'package:stringer/core/error/failure.dart';

import '../dto/debtor_dto.dart';

/// Parses the customer debt-aging export produced by the accounting system.
///
/// The real file has a handful of metadata rows (company name, report date,
/// etc.) before the actual header row, so the header can't be assumed to be
/// row 0 - it's found by scanning for the first row that resolves every
/// required column.
@injectable
class DebtorsExcelDataSource {
  static const _maxHeaderScanRows = 30;
  static const _totalsRowMarkers = ['total', 'ukupno'];

  Future<List<DebtorDto>> readDebtors(String filePath) async {
    if (!filePath.toLowerCase().endsWith('.xlsx')) {
      throw const AppException(Failure(FailureType.invalidFileFormat));
    }

    final file = File(filePath);
    if (!await file.exists()) {
      throw const AppException(Failure(FailureType.invalidFileFormat));
    }

    final bytes = await file.readAsBytes();

    final xlsx.Excel workbook;
    try {
      workbook = xlsx.Excel.decodeBytes(bytes);
    } catch (_) {
      throw const AppException(Failure(FailureType.invalidFileFormat));
    }

    if (workbook.tables.isEmpty) {
      throw const AppException(Failure(FailureType.invalidFileFormat));
    }

    final sheet = workbook.tables[workbook.tables.keys.first]!;
    final rows = sheet.rows;

    if (rows.isEmpty) {
      return const [];
    }

    final headerScanLimit = rows.length < _maxHeaderScanRows
        ? rows.length
        : _maxHeaderScanRows;

    _ColumnIndexes? columns;
    var headerRowIndex = -1;
    for (var i = 0; i < headerScanLimit; i++) {
      columns = _resolveColumns(rows[i]);
      if (columns != null) {
        headerRowIndex = i;
        break;
      }
    }

    if (columns == null) {
      throw const AppException(Failure(FailureType.missingColumns));
    }

    return rows
        .skip(headerRowIndex + 1)
        .where((row) => !_shouldSkipRow(row, columns!))
        .map(
          (row) => DebtorDto(
            code: _cellText(row, columns!.code),
            companyName: _cellText(row, columns.company),
            pib: _cellText(row, columns.pib),
            currency: _cellText(row, columns.currency),
            totalDebtRaw: _cellText(row, columns.totalDebt),
            currentDebtRaw: _cellText(row, columns.currentDebt),
            overdueUpTo7DaysRaw: _cellText(row, columns.overdueUpTo7Days),
            overdueUpTo15DaysRaw: _cellText(row, columns.overdueUpTo15Days),
            overdueUpTo30DaysRaw: _cellText(row, columns.overdueUpTo30Days),
            overdueUpTo60DaysRaw: _cellText(row, columns.overdueUpTo60Days),
            overdueOver60DaysRaw: _cellText(row, columns.overdueOver60Days),
          ),
        )
        .toList();
  }

  _ColumnIndexes? _resolveColumns(List<xlsx.Data?> headerRow) {
    int? code;
    int? company;
    int? pib;
    int? currency;
    int? totalDebt;
    int? currentDebt;
    int? overdueUpTo7Days;
    int? overdueUpTo15Days;
    int? overdueUpTo30Days;
    int? overdueUpTo60Days;
    int? overdueOver60Days;

    for (var i = 0; i < headerRow.length; i++) {
      final raw = headerRow[i]?.value?.toString();
      if (raw == null || raw.trim().isEmpty) continue;
      final header = _normalize(raw);

      if (header == 'sifra') {
        code ??= i;
      } else if (_isCompanyHeader(header)) {
        company ??= i;
      } else if (header == 'pib') {
        pib ??= i;
      } else if (header == 'deviza') {
        currency ??= i;
      } else if (header == 'ukupandug') {
        totalDebt ??= i;
      } else if (header == 'duguroku') {
        currentDebt ??= i;
      } else if (header == 'dugrok+7') {
        overdueUpTo7Days ??= i;
      } else if (header == 'dugrok+15') {
        overdueUpTo15Days ??= i;
      } else if (header == 'dugrok+30') {
        overdueUpTo30Days ??= i;
      } else if (header == 'dugrok+60') {
        overdueUpTo60Days ??= i;
      } else if (header == 'dugpreko60') {
        overdueOver60Days ??= i;
      }
    }

    if (code == null ||
        company == null ||
        pib == null ||
        currency == null ||
        totalDebt == null ||
        currentDebt == null ||
        overdueUpTo7Days == null ||
        overdueUpTo15Days == null ||
        overdueUpTo30Days == null ||
        overdueUpTo60Days == null ||
        overdueOver60Days == null) {
      return null;
    }

    return _ColumnIndexes(
      code: code,
      company: company,
      pib: pib,
      currency: currency,
      totalDebt: totalDebt,
      currentDebt: currentDebt,
      overdueUpTo7Days: overdueUpTo7Days,
      overdueUpTo15Days: overdueUpTo15Days,
      overdueUpTo30Days: overdueUpTo30Days,
      overdueUpTo60Days: overdueUpTo60Days,
      overdueOver60Days: overdueOver60Days,
    );
  }

  bool _isCompanyHeader(String normalized) {
    const aliases = ['nazivposlovnogpartnera', 'nazivkupca', 'nazivkomitenta'];
    if (aliases.contains(normalized)) return true;
    return normalized.contains('naziv') &&
        (normalized.contains('partner') ||
            normalized.contains('kupc') ||
            normalized.contains('komitent'));
  }

  bool _shouldSkipRow(List<xlsx.Data?> row, _ColumnIndexes columns) {
    final companyName = _cellText(row, columns.company);
    if (companyName.isEmpty) return true;
    return _totalsRowMarkers.contains(_normalize(companyName));
  }

  String _cellText(List<xlsx.Data?> row, int index) {
    if (index >= row.length) return '';
    return row[index]?.value?.toString().trim() ?? '';
  }

  /// Lowercases, strips Serbian diacritics, and removes whitespace/dots so
  /// header variants like "Dug.rok+7" and "Ukupan dug" compare reliably.
  String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('š', 's')
        .replaceAll('đ', 'dj')
        .replaceAll('č', 'c')
        .replaceAll('ć', 'c')
        .replaceAll('ž', 'z')
        .replaceAll(RegExp(r'[\s.]'), '');
  }
}

class _ColumnIndexes {
  final int code;
  final int company;
  final int pib;
  final int currency;
  final int totalDebt;
  final int currentDebt;
  final int overdueUpTo7Days;
  final int overdueUpTo15Days;
  final int overdueUpTo30Days;
  final int overdueUpTo60Days;
  final int overdueOver60Days;

  const _ColumnIndexes({
    required this.code,
    required this.company,
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
}
