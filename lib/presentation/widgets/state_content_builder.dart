import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class StateContentBuilder<B extends Bloc, S> extends StatelessWidget {
  // Note: Every BLoC should have 5 states; Inital, Loading, Loaded, Error, ActionSuccess.
  const StateContentBuilder({super.key});

  // State builder methods
  Widget buildLoadingContent() =>
      const Center(child: CircularProgressIndicator());

  Widget buildErrorContent(String message) => Text('Error: $message');

  Widget buildUnknownContent() => const Text('Unknown state');

  Widget buildLoadedContent(BuildContext context, dynamic state);

  Widget builder<T>(
    BuildContext context,
    T state,
  ) {
    return switch (state) {
      final state when state.toString().contains('Loading') =>
        buildLoadingContent(),
      final state when state.toString().contains('Loaded') =>
        buildLoadedContent(context, state),
      final state when state.toString().contains('Error') =>
        buildErrorContent((state as dynamic).message as String),
      _ => buildUnknownContent(),
    };
  }

  // State listener methods
  bool shouldShowMessage(S state) {
    return state.toString().contains('Error') ||
        state.toString().contains('Success');
  }

  void listener(BuildContext context, S state) {
    if (shouldShowMessage(state)) {
      final message = (state as dynamic).message as String?;
      if (message != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        onAfterMessage(context);
      }
    }
  }

  void onAfterMessage(BuildContext context) {}
}
