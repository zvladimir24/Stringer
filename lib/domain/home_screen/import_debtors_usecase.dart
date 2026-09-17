import 'package:injectable/injectable.dart';

import '../models/debtor.dart';
import 'home_screen_repository.dart';

@injectable
class ImportDebtorsUseCase {
  final HomeScreenRepository repository;

  const ImportDebtorsUseCase(this.repository);

  Future<List<Debtor>> call(String filePath) {
    return repository.importDebtors(filePath);
  }
}
