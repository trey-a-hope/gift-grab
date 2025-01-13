import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin SmartBlocMixin<B extends Bloc, S> {
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

  bool shouldShowMessage(S state) {
    return state.toString().contains('Error') ||
        state.toString().contains('Success');
  }

  void listener(BuildContext context, S state) {
    if (shouldShowMessage(state)) {
      final message = (state as dynamic).message as String?;
      if (message != null) {
        // TODO: Update with visually more appealing toast.
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        onAfterMessage(context);
      }
    }
  }

  void onAfterMessage(BuildContext context) {}
}
