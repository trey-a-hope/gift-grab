import 'package:formz/formz.dart';

enum _CommentValidationError { empty, tooShort, tooLong }

class Comment extends FormzInput<String, _CommentValidationError> {
  static const int min = 10;
  static const int max = 100;
  static const int maxLines = 3;
  static const int minLines = 2;

  const Comment.pure() : super.pure('');
  const Comment.dirty([super.value = '']) : super.dirty();

  @override
  _CommentValidationError? validator(String value) {
    if (value.isEmpty) return _CommentValidationError.empty;
    if (value.length < min) return _CommentValidationError.tooShort;
    if (value.length > max) return _CommentValidationError.tooLong;
    return null;
  }

  String? get errorMessage {
    switch (displayError) {
      case _CommentValidationError.empty:
        return 'Comment is required';
      case _CommentValidationError.tooShort:
        return 'Comment must be at least $min characters';
      case _CommentValidationError.tooLong:
        return 'Comment must not exceed $max characters';
      default:
        return null;
    }
  }
}
