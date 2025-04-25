part of 'search_users_bloc.dart';

sealed class SearchUsersEvent {}

class SearchUser extends SearchUsersEvent {
  final String username;
  SearchUser(this.username);
}
