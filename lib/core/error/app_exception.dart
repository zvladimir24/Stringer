import 'failure.dart';

class AppException implements Exception {
  final Failure failure;

  const AppException(this.failure);

  @override
  String toString() => 'AppException(${failure.type})';
}
