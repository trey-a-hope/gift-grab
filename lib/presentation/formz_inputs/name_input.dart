import 'package:flutter/material.dart';
import 'package:gift_grab/presentation/formz_inputs/name.dart';

class NameInput extends StatelessWidget {
  final Name name;
  final void Function(String)? onChanged;

  const NameInput(
    this.name, {
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      onChanged: onChanged,
      style: theme.textTheme.displayLarge,
      decoration: InputDecoration(
        labelText: 'Name',
        labelStyle: theme.textTheme.displayLarge?.copyWith(color: Colors.grey),
        prefixIcon: const Icon(
          Icons.person,
          color: Colors.white,
        ),
        border: const OutlineInputBorder(),
        errorText: name.errorMessage,
        errorStyle: theme.textTheme.headlineSmall?.copyWith(color: Colors.red),
      ),
      textInputAction: TextInputAction.next,
    );
  }
}
