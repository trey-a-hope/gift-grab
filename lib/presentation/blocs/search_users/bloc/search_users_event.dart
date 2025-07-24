part of 'search_users_bloc.dart';

sealed class SearchUsersEvent extends Equatable {
  const SearchUsersEvent();
}

class SearchUser extends SearchUsersEvent {
  final String username;

  const SearchUser(this.username);

  @override
  List<Object?> get props => [username];
}

class ClearSearch extends SearchUsersEvent {
  const ClearSearch();

  @override
  List<Object?> get props => [];
}
