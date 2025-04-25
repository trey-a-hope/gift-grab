part of 'search_users_bloc.dart';

class SearchUsersState {
  final String query;
  final List<User> users;
  final bool isLoading;
  final String? error;

  const SearchUsersState({
    this.query = '',
    this.users = const [],
    this.isLoading = false,
    this.error,
  });

  SearchUsersState copyWith({
    String? query,
    List<User>? users,
    bool? isLoading,
    String? error,
  }) =>
      SearchUsersState(
        query: query ?? this.query,
        users: users ?? this.users,
        isLoading: isLoading == true ? true : false,
        error: error,
      );
}
