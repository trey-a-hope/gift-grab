part of 'search_users_bloc.dart';

class SearchUsersState {
  final String query;
  SearchUsersState({required this.query});
}

class SearchUsersLoading extends SearchUsersState {
  SearchUsersLoading({required super.query});
}

class SearchUsersLoaded extends SearchUsersState {
  final List<User> users;

  SearchUsersLoaded({required this.users, required super.query});
}

class SearchUsersActionSuccess extends SearchUsersState {
  final String message;

  SearchUsersActionSuccess({required this.message, required super.query});
}

class SearchUsersError extends SearchUsersState {
  final String message;

  SearchUsersError({required this.message, required super.query});
}
