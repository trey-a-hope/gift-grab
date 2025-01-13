import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';

mixin GrpcErrorHandlerMixin<T> {
  final Map<String, String> _defaultErrorMessages = {
    'NOT_FOUND': 'Account not found. Please check your credentials.',
    'INVALID_ARGUMENT': 'Invalid input provided.',
    'UNAUTHENTICATED': 'Authentication token invalid.',
    'PERMISSION_DENIED':
        'Cannot unlink last account identifier. Check profile exists and is not last link.',
  };

  void handleGrpcError(GrpcError e, Emitter<T> emit,
      T Function(String message) errorStateBuilder) {
    final message =
        _defaultErrorMessages[e.codeName] ?? 'Operation failed: ${e.message}';
    emit(errorStateBuilder(message));
  }
}
