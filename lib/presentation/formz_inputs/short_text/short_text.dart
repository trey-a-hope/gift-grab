import 'package:formz/formz.dart';

enum _ShortTextValidationError { empty, tooShort }

class ShortText extends FormzInput<String, _ShortTextValidationError> {
  static const int _minCharCount = 6;

  const ShortText.pure() : super.pure('');
  const ShortText.dirty([super.value = '']) : super.dirty();

  @override
  _ShortTextValidationError? validator(String value) {
    if (value.isEmpty) return _ShortTextValidationError.empty;
    if (value.length < _minCharCount) return _ShortTextValidationError.tooShort;
    return null;
  }

  String? get errorMessage {
    switch (displayError) {
      case _ShortTextValidationError.empty:
        return 'This field is required';
      case _ShortTextValidationError.tooShort:
        return 'This field must be at least $_minCharCount characters';
      default:
        return null;
    }
  }
}
