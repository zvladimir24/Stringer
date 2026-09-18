enum FailureType {
  invalidFileFormat,
  missingColumns,
  fileReadError,
  smtpNotConfigured,
  sendFailed,
  missingEmailSubject,
}

class Failure {
  final FailureType type;
  final String? details;

  const Failure(this.type, {this.details});
}
