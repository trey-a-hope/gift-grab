import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/modal_service.dart';

abstract class SmartBloc<B extends Bloc, S> extends StatelessWidget {
  static const _error = 'Error';
  static const _loading = 'Loading';
  static const _loaded = 'Loaded';
  static const _success = 'Success';
  static const _unknown = 'Unknown';

  const SmartBloc({super.key});
  Widget buildLoadingContent() =>
      const Center(child: CircularProgressIndicator());
  Widget buildErrorContent(String message) => Text('$_error: $message');
  Widget buildUnknownContent() => const Text('$_unknown state');
  Widget buildLoadedContent(BuildContext context, dynamic state);

  Widget builder<T>(BuildContext context, T state) => switch (state) {
        final state when state.toString().contains(_loading) =>
          buildLoadingContent(),
        final state when state.toString().contains(_loaded) =>
          buildLoadedContent(context, state),
        final state when state.toString().contains(_error) =>
          buildErrorContent((state as dynamic).message as String),
        _ => buildUnknownContent(),
      };

  bool shouldShowMessage(S state) =>
      state.toString().contains(_error) || state.toString().contains(_success);

  void listener(BuildContext context, S state) {
    if (shouldShowMessage(state)) {
      final message = (state as dynamic).message as String?;
      if (message != null) {
        if (state.toString().contains(_error)) {
          ModalService.showError(title: message);
        }

        if (state.toString().contains(_success)) {
          ModalService.showSuccess(title: message);
        }

        onAfterMessage(context);
      }
    }
  }

  // TODO: Could remove this method and instead use super.listener, then add any action after.
  void onAfterMessage(BuildContext context) {}
}
