part of 'group_users_bloc.dart';

sealed class GroupUsersEvent {
  const GroupUsersEvent();
}

class ListGroupUsers extends GroupUsersEvent {
  const ListGroupUsers();
}
