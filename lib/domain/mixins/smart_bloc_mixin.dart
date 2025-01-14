import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/modal_service.dart';

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
    debugPrint('\n=== Listener Called ===');
    debugPrint('State type: ${state.runtimeType}');
    debugPrint('Should show message: ${shouldShowMessage(state)}');
    debugPrint('Stack trace: ${StackTrace.current}');

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

  // TODO: Remove {} and make every subclass have to override this method.
  void onAfterMessage(BuildContext context) {}
}
