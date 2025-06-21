import 'package:flutter/material.dart';
import 'package:gift_grab/presentation/formz_inputs/comment.dart';

class CommentInput extends StatelessWidget {
  final Comment comment;
  final String? labelText;
  final String? helperText;
  final void Function(String) onChanged;

  const CommentInput(
    this.comment, {
    this.labelText,
    this.helperText,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      onChanged: onChanged,
      style: theme.textTheme.displayLarge,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: theme.textTheme.displayLarge?.copyWith(color: Colors.grey),
        prefixIcon: const Icon(Icons.description),
        border: const OutlineInputBorder(),
        errorText: comment.errorMessage,
        errorStyle: theme.textTheme.headlineSmall?.copyWith(color: Colors.red),
        helperText: helperText,
      ),
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      maxLines: Comment.maxLines,
      minLines: Comment.minLines,
      maxLength: Comment.max,
    );
  }
}
