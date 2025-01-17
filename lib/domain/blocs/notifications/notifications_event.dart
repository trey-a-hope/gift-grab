part of 'notifications_bloc.dart';

sealed class NotificationsEvent {}

class FetchNotifications extends NotificationsEvent {}

class FetchMoreNotifications extends NotificationsEvent {}
