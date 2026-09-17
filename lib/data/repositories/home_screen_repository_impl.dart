import 'package:injectable/injectable.dart';
import 'package:stringer/domain/home_screen/home_screen_repository.dart';
import 'package:stringer/domain/models/debtor.dart';

import '../datasources/debtors_excel_data_source.dart';
import '../dto/debtor_dto.dart';

@LazySingleton(as: HomeScreenRepository)
class HomeScreenRepositoryImpl implements HomeScreenRepository {
  final DebtorsExcelDataSource dataSource;

  const HomeScreenRepositoryImpl(this.dataSource);

  @override
  Future<List<Debtor>> importDebtors(String filePath) async {
    final dtos = await dataSource.readDebtors(filePath);
    return dtos.map((dto) => dto.toDomain()).toList();
  }
}
