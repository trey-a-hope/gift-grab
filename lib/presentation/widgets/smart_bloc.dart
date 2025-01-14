import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/modal_service.dart';

// Alleviate some boiler plate code when dealing with the
// listener and builder methods for a Bloc Consumer.
abstract class SmartBloc<B extends Bloc, S> extends StatelessWidget {
  const SmartBloc({super.key});

  Widget buildLoadingContent() =>
      const Center(child: CircularProgressIndicator());

  Widget buildErrorContent(String message) => Text('Error: $message');

  Widget buildUnknownContent() => const Text('Unknown state');

  Widget buildLoadedContent(BuildContext context, dynamic state);

  Widget builder<T>(BuildContext context, T state) {
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
        if (state.toString().contains('Error')) {
          ModalService.showError(title: message);
        }

        if (state.toString().contains('Success')) {
          ModalService.showSuccess(title: message);
        }

        onAfterMessage(context);
      }
    }
  }

  void onAfterMessage(BuildContext context) {}
}
