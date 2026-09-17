import 'dart:io';

import 'package:excel/excel.dart' as xlsx;
import 'package:flutter_test/flutter_test.dart';
import 'package:stringer/core/error/app_exception.dart';
import 'package:stringer/core/error/failure.dart';
import 'package:stringer/data/datasources/debtors_excel_data_source.dart';
import 'package:stringer/data/dto/debtor_dto.dart';

void main() {
  late DebtorsExcelDataSource dataSource;

  setUp(() {
    dataSource = DebtorsExcelDataSource();
  });

  Future<String> writeWorkbook(xlsx.Excel workbook) async {
    final file = File(
      '${Directory.systemTemp.path}/debtors_test_${DateTime.now().microsecondsSinceEpoch}.xlsx',
    );
    await file.writeAsBytes(workbook.encode()!);
    addTearDown(() => file.delete());
    return file.path;
  }

  void setCell(xlsx.Sheet sheet, int col, int row, xlsx.CellValue value) {
    sheet
        .cell(xlsx.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
        .value = value;
  }

  test(
    'parses the real aging-report shape: metadata rows, header row found by '
    'scanning, and blank bucket cells treated as zero',
    () async {
      final workbook = xlsx.Excel.createExcel();
      final sheet = workbook['Sheet1'];

      // Metadata rows the real export has before the header.
      setCell(sheet, 0, 0, xlsx.TextCellValue('MET INZENJERING 021 DOO NOVI SAD'));
      setCell(sheet, 0, 1, xlsx.TextCellValue('NOVI SAD'));
      setCell(sheet, 0, 2, xlsx.TextCellValue('Datum: 08.09.2026'));

      // Header row (row 3), with unrelated columns mixed in, matching the
      // real export's column order.
      setCell(sheet, 0, 3, xlsx.TextCellValue('Sifra'));
      setCell(sheet, 1, 3, xlsx.TextCellValue('Naziv poslovnog partnera'));
      setCell(sheet, 2, 3, xlsx.TextCellValue('Deviza'));
      setCell(sheet, 3, 3, xlsx.TextCellValue('Ukupan dug'));
      setCell(sheet, 4, 3, xlsx.TextCellValue('Dug u roku'));
      setCell(sheet, 5, 3, xlsx.TextCellValue('Dug.rok+7'));
      setCell(sheet, 6, 3, xlsx.TextCellValue('Dug.rok+15'));
      setCell(sheet, 7, 3, xlsx.TextCellValue('Dug.rok+30'));
      setCell(sheet, 8, 3, xlsx.TextCellValue('Dug.rok+60'));
      setCell(sheet, 9, 3, xlsx.TextCellValue('Dug.preko60'));
      setCell(sheet, 10, 3, xlsx.TextCellValue('PIB'));

      // Data row (row 4). Buckets other than +30 are left blank on purpose.
      setCell(sheet, 0, 4, xlsx.TextCellValue('1875'));
      setCell(sheet, 1, 4, xlsx.TextCellValue('ZENIT KOP DOO BEOGRAD'));
      setCell(sheet, 2, 4, xlsx.TextCellValue('DIN'));
      setCell(sheet, 3, 4, xlsx.DoubleCellValue(908675));
      setCell(sheet, 4, 4, xlsx.DoubleCellValue(45306));
      setCell(sheet, 7, 4, xlsx.DoubleCellValue(863369));
      setCell(sheet, 10, 4, xlsx.TextCellValue('100605969'));

      final path = await writeWorkbook(workbook);
      final dtos = await dataSource.readDebtors(path);
      final debtors = dtos.map((dto) => dto.toDomain()).toList();

      expect(debtors, hasLength(1));
      final debtor = debtors.single;
      expect(debtor.code, '1875');
      expect(debtor.companyName, 'ZENIT KOP DOO BEOGRAD');
      expect(debtor.pib, '100605969');
      expect(debtor.totalDebt, 908675);
      expect(debtor.currentDebt, 45306);
      expect(debtor.overdueUpTo7Days, 0);
      expect(debtor.overdueUpTo15Days, 0);
      expect(debtor.overdueUpTo30Days, 863369);
      expect(debtor.overdueUpTo60Days, 0);
      expect(debtor.overdueOver60Days, 0);
      expect(debtor.totalOverdue, 863369);
    },
  );

  test(
    'treats a blank Ukupan dug / Dug u roku as zero instead of failing '
    '(real exports have rows with only FK/adjustment columns populated)',
    () async {
      final workbook = xlsx.Excel.createExcel();
      final sheet = workbook['Sheet1'];

      setCell(sheet, 0, 0, xlsx.TextCellValue('Sifra'));
      setCell(sheet, 1, 0, xlsx.TextCellValue('Naziv poslovnog partnera'));
      setCell(sheet, 2, 0, xlsx.TextCellValue('Deviza'));
      setCell(sheet, 3, 0, xlsx.TextCellValue('Ukupan dug'));
      setCell(sheet, 4, 0, xlsx.TextCellValue('Dug u roku'));
      setCell(sheet, 5, 0, xlsx.TextCellValue('Dug.rok+7'));
      setCell(sheet, 6, 0, xlsx.TextCellValue('Dug.rok+15'));
      setCell(sheet, 7, 0, xlsx.TextCellValue('Dug.rok+30'));
      setCell(sheet, 8, 0, xlsx.TextCellValue('Dug.rok+60'));
      setCell(sheet, 9, 0, xlsx.TextCellValue('Dug.preko60'));
      setCell(sheet, 10, 0, xlsx.TextCellValue('PIB'));

      // Mirrors "AERO VELA D..." from the real file: no Ukupan dug / Dug u
      // roku at all, only an unrelated adjustment column populated.
      setCell(sheet, 0, 1, xlsx.TextCellValue('109624594'));
      setCell(sheet, 1, 1, xlsx.TextCellValue('AERO VELA DOO'));
      setCell(sheet, 2, 1, xlsx.TextCellValue('DIN'));
      setCell(sheet, 10, 1, xlsx.TextCellValue('109624594'));

      final path = await writeWorkbook(workbook);
      final dtos = await dataSource.readDebtors(path);
      final debtors = dtos.map((dto) => dto.toDomain()).toList();

      expect(debtors, hasLength(1));
      expect(debtors.single.totalDebt, 0);
      expect(debtors.single.currentDebt, 0);
      expect(debtors.single.totalOverdue, 0);
      expect(debtors.single.hasOutstandingDebt, isFalse);
    },
  );

  test('throws missingColumns when required headers are absent', () async {
    final workbook = xlsx.Excel.createExcel();
    final sheet = workbook['Sheet1'];
    setCell(sheet, 0, 0, xlsx.TextCellValue('Naziv'));
    setCell(sheet, 1, 0, xlsx.TextCellValue('Iznos'));
    setCell(sheet, 0, 1, xlsx.TextCellValue('Neko'));
    setCell(sheet, 1, 1, xlsx.DoubleCellValue(100));

    final path = await writeWorkbook(workbook);

    await expectLater(
      dataSource.readDebtors(path),
      throwsA(
        isA<AppException>().having(
          (e) => e.failure.type,
          'type',
          FailureType.missingColumns,
        ),
      ),
    );
  });
}
