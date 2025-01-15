import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/modal_service.dart';

/// A smart widget that handles common Bloc state patterns and provides default UI implementations
/// for different states (loading, error, etc.).
///
/// Generic parameters:
/// - [B]: The type of Bloc this widget will consume
/// - [S]: The type of State associated with the Bloc
///
/// This class reduces boilerplate by providing common implementations for state handling
/// and UI rendering based on state string contents.
abstract class SmartBloc<B extends Bloc, S> extends StatelessWidget {
  // Constants for state string matching
  static const _error = 'Error';
  static const _loading = 'Loading';
  static const _loaded = 'Loaded';
  static const _success = 'Success';
  static const _unknown = 'Unknown';

  /// Creates a SmartBloc widget.
  ///
  /// The [key] parameter is optional and is passed to the parent [StatelessWidget].
  const SmartBloc({super.key});

  // MARK: - Builder Methods

  /// Builds the UI for loading states.
  ///
  /// Returns a centered circular progress indicator by default.
  Widget buildLoadingContent() =>
      const Center(child: CircularProgressIndicator());

  /// Builds the UI for error states.
  ///
  /// [message] contains the error message to be displayed.
  /// Returns a text widget with the error message prefixed with "Error:".
  Widget buildErrorContent(String message) => Text('$_error: $message');

  /// Builds the UI for unknown/unhandled states.
  ///
  /// Returns a text widget indicating an unknown state.
  Widget buildUnknownContent() => const Text('$_unknown state');

  /// Abstract method that must be implemented by subclasses to build the UI for loaded states.
  ///
  /// [context] is the current build context.
  /// [state] is the current state object, typed as dynamic to allow for different state types.
  Widget buildLoadedContent(BuildContext context, dynamic state);

  /// Main builder method that determines which UI to show based on the current state.
  ///
  /// [context] is the current build context.
  /// [state] is the current state object.
  ///
  /// Uses string matching on the state's toString() value to determine the current state type.
  /// Returns the appropriate UI widget based on the state:
  /// - Loading state -> buildLoadingContent()
  /// - Loaded state -> buildLoadedContent()
  /// - Error state -> buildErrorContent()
  /// - Unknown state -> buildUnknownContent()
  Widget builder<T>(BuildContext context, T state) => switch (state) {
        final state when state.toString().contains(_loading) =>
          buildLoadingContent(),
        final state when state.toString().contains(_loaded) =>
          buildLoadedContent(context, state),
        final state when state.toString().contains(_error) =>
          buildErrorContent((state as dynamic).message as String),
        _ => buildUnknownContent(),
      };

  /// Determines if a message should be shown for the current state.
  ///
  /// [state] is the current state object.
  /// Returns true if the state contains either 'Error' or 'Success' in its string representation.
  bool shouldShowMessage(S state) {
    return state.toString().contains(_error) ||
        state.toString().contains(_success);
  }

  // MARK: - Listener Methods

  /// Main listener method that handles showing modals based on state changes.
  ///
  /// [context] is the current build context.
  /// [state] is the current state object.
  ///
  /// This method:
  /// 1. Checks if a message should be shown for the current state
  /// 2. Extracts the message from the state object
  /// 3. Shows either an error or success modal based on the state type
  /// 4. Calls onAfterMessage() after showing the modal
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

  /// Hook method called after showing a message modal.
  ///
  /// [context] is the current build context.
  ///
  /// This method can be overridden by subclasses to perform actions after
  /// a message has been shown to the user.
  void onAfterMessage(BuildContext context) {}
}
