import 'package:formz/formz.dart';

// TODO: Change to Range
enum _SliderValidationError { belowMin, aboveMax }

class Slider extends FormzInput<int, _SliderValidationError> {
  final int min = 2;
  final int max = 10;
  const Slider.pure({
    int value = 2,
  }) : super.pure(value);

  const Slider.dirty(int value) : super.dirty(value);

  @override
  _SliderValidationError? validator(int value) {
    if (value < min) return _SliderValidationError.belowMin;
    if (value > max) return _SliderValidationError.aboveMax;
    return null;
  }

  String? get errorMessage {
    switch (displayError) {
      case _SliderValidationError.belowMin:
        return 'Value must be at least $min';
      case _SliderValidationError.aboveMax:
        return 'Value must not exceed $max';
      default:
        return null;
    }
  }
}
