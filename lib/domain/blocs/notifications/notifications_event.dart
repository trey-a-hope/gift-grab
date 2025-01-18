part of 'notifications_bloc.dart';

sealed class NotificationsEvent {}

class FetchNotifications extends NotificationsEvent {}

class FetchMoreNotifications extends NotificationsEvent {}

class DeleteNotification extends NotificationsEvent {
  final String id;
  DeleteNotification({required this.id});
}

// class AcceptFriendRequest extends NotificationsEvent {
//   final String username;
//   AcceptFriendRequest({required this.username});
// }
