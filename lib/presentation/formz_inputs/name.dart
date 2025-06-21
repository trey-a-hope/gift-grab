import 'package:formz/formz.dart';

enum _NameValidationError { empty, tooShort }

class Name extends FormzInput<String, _NameValidationError> {
  static const int _minCharCount = 6;

  const Name.pure() : super.pure('');
  const Name.dirty([super.value = '']) : super.dirty();

  @override
  _NameValidationError? validator(String value) {
    if (value.isEmpty) return _NameValidationError.empty;
    if (value.length < _minCharCount) return _NameValidationError.tooShort;
    return null;
  }

  String? get errorMessage {
    switch (displayError) {
      case _NameValidationError.empty:
        return 'Name is required';
      case _NameValidationError.tooShort:
        return 'Name must be at least $_minCharCount characters';
      default:
        return null;
    }
  }
}
