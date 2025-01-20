part of 'notifications_bloc.dart';

class NotificationsState {
  final String? cursor;
  NotificationsState({required this.cursor});
}

class NotificationsInitial extends NotificationsState {
  NotificationsInitial({required super.cursor});
}

class NotificationsLoading extends NotificationsState {
  NotificationsLoading({required super.cursor});
}

class NotificationsLoaded extends NotificationsState {
  final List<n.Notification> notifications;

  NotificationsLoaded({
    required this.notifications,
    required super.cursor,
  });
}

class NotificationsError extends NotificationsState {
  final String message;

  NotificationsError({
    required this.message,
    required super.cursor,
  });
}

class NotificationsSuccess extends NotificationsState {
  final String message;

  NotificationsSuccess({
    required this.message,
    required super.cursor,
  });
}
