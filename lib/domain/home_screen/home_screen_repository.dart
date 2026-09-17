import '../models/debtor.dart';

abstract class HomeScreenRepository {
  Future<List<Debtor>> importDebtors(String filePath);
}
