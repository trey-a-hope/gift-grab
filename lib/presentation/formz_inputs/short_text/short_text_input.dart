import 'package:flutter/material.dart';
import 'package:gift_grab/presentation/formz_inputs/short_text/view.dart';

class ShortTextInput extends StatelessWidget {
  final ShortText shortText;
  final String labelText;
  final void Function(String)? onChanged;

  const ShortTextInput(
    this.shortText, {
    required this.labelText,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      initialValue: shortText.value,
      onChanged: onChanged,
      style: theme.textTheme.displayLarge,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: theme.textTheme.displayLarge?.copyWith(color: Colors.grey),
        prefixIcon: const Icon(
          Icons.person,
          color: Colors.white,
        ),
        border: const OutlineInputBorder(),
        errorText: shortText.errorMessage,
        errorStyle: theme.textTheme.headlineSmall?.copyWith(color: Colors.red),
      ),
      textInputAction: TextInputAction.next,
    );
  }
}
