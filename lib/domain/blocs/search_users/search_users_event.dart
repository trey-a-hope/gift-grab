part of 'search_users_bloc.dart';

sealed class SearchUsersEvent {
  const SearchUsersEvent();
}

class SearchUser extends SearchUsersEvent {
  final String username;

  SearchUser({required this.username});
}
