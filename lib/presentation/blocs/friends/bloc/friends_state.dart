part of 'friends_bloc.dart';

class FriendsState extends BaseState {
  final bool isLoading;
  final String? success;
  final String? error;

  FriendsState({
    this.isLoading = true,
    this.success,
    this.error,
  });

  FriendsState copyWith({
    bool? isLoading,
    String? success,
    String? error,
  }) =>
      FriendsState(
        isLoading: isLoading == true ? true : false,
        success: success,
        error: error,
      );
}
