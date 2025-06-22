import 'package:flutter/material.dart';
import 'package:gift_grab/presentation/formz_inputs/long_text/long_text.dart';

class LongTextInput extends StatelessWidget {
  final LongText longText;
  final String? labelText;
  final String? helperText;
  final void Function(String) onChanged;

  const LongTextInput(
    this.longText, {
    this.labelText,
    this.helperText,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      initialValue: longText.value,
      onChanged: onChanged,
      style: theme.textTheme.displayLarge,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: theme.textTheme.displayLarge?.copyWith(color: Colors.grey),
        prefixIcon: const Icon(Icons.description),
        border: const OutlineInputBorder(),
        errorText: longText.errorMessage,
        errorStyle: theme.textTheme.headlineSmall?.copyWith(color: Colors.red),
        helperText: helperText,
      ),
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      maxLines: LongText.maxLines,
      minLines: LongText.minLines,
      maxLength: LongText.max,
    );
  }
}
