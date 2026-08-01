import 'failure.dart';

class ValidationFailure extends Failure {
  final Map<String, String> errors;

  const ValidationFailure({
    super.message = 'بيانات مدخلة غير صالحة',
    super.code = 'VALIDATION_ERROR',
    this.errors = const {},
  });

  @override
  List<Object?> get props => [message, code, errors];
}
