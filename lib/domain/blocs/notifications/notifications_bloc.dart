import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/data/services/web_socket_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';
import 'package:nakama/src/models/notification.dart' as n;

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final AuthBloc authBloc;
  final NakamaService _nakamaService;
  final WebSocketService _webSocketService;

  StreamSubscription? _notificationSubscription;
  StreamSubscription? _statusSubscription;

  NotificationsBloc({
    required this.authBloc,
  })  : _nakamaService = NakamaService(),
        _webSocketService = WebSocketService(),
        super(NotificationsInitial(cursor: null)) {
    on<FetchNotifications>(_onFetchNotifications);
    on<FetchMoreNotifications>(_onFetchMoreNotifications);
    on<DeleteNotification>(_onDeleteNotification);

    _initializeWebSocket();
  }

  Future<void> _initializeWebSocket() async {
    final session = await _nakamaService.getValidSessionOrLogout(authBloc);
    if (session == null) return;

    // Listen for notifications.
    _notificationSubscription =
        _webSocketService.socket?.onNotifications.listen(
      (notification) {
        ModalService.showSuccess(title: notification.subject ?? 'New Message');
        add(FetchNotifications());
        debugPrint(notification.toString());
      },
    );

    // Listen for statuses.
    _statusSubscription = _webSocketService.socket?.onStatusPresence.listen(
      (presence) {
        debugPrint('[onStatusPresence]');
        for (final join in presence.joins) {
          if (session.userId == join.userId) {
            ModalService.showSuccess(title: 'Join: FROM YOU!');
            return;
          }

          final alert = 'Join: ${join.username} is ${join.status}';
          ModalService.showSuccess(title: alert);
          debugPrint('join - $alert');
        }
        for (final leave in presence.leaves) {
          if (session.userId == leave.userId) {
            ModalService.showSuccess(title: 'Leave: FROM YOU!');
            return;
          }

          final alert = 'Leave: ${leave.username} is ${leave.status}';
          ModalService.showError(title: alert);
          debugPrint('leave - $alert');
        }
      },
    );

    // Follow all friends.
    final friendsList = await getNakamaClient().listFriends(
      session: session,
    );
    final uidsOfFriends =
        friendsList.friends?.map((friend) => friend.user.id).toList();
    if (uidsOfFriends != null) {
      var statuses = await _webSocketService.socket?.followUsers(
        userIds: uidsOfFriends,
      );

      if (statuses != null) {
        for (var status in statuses) {
          final alert =
              'User ID: ${status.userId} Username: ${status.username} Status: ${status.status}';
          debugPrint(alert);
        }
      }
    }
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    _statusSubscription?.cancel();
    return super.close();
  }

  Future<void> _onFetchNotifications(
    FetchNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading(cursor: state.cursor));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);
      if (session == null) return;

      final notificationList = await getNakamaClient().listNotifications(
        session: session,
        limit: Globals.paginationLimit,
      );

      final cursor =
          notificationList.cursor == '' ? null : notificationList.cursor;

      emit(
        NotificationsLoaded(
          notifications: notificationList.notifications,
          cursor: cursor,
        ),
      );
    } on GrpcError catch (e) {
      emit(NotificationsError(
          cursor: state.cursor,
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(NotificationsError(
          cursor: state.cursor, message: 'Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onFetchMoreNotifications(
    FetchMoreNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading(cursor: state.cursor));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);
      if (session == null) return;

      final notificationList = await getNakamaClient().listNotifications(
        session: session,
        limit: Globals.paginationLimit,
        cursor: state.cursor,
      );

      final cursor =
          notificationList.cursor == '' ? null : notificationList.cursor;

      emit(
        NotificationsLoaded(
          notifications: notificationList.notifications,
          cursor: cursor,
        ),
      );
    } on GrpcError catch (e) {
      emit(NotificationsError(
          cursor: state.cursor,
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(
        NotificationsError(
          cursor: state.cursor,
          message: 'Unexpected error: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading(cursor: state.cursor));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);
      if (session == null) return;

      await getNakamaClient().deleteNotifications(
        session: session,
        notificationIds: [event.id],
      );

      emit(
        NotificationsSuccess(
          message: 'Notification deleted successfully',
          cursor: state.cursor,
        ),
      );
    } on GrpcError catch (e) {
      emit(NotificationsError(
          cursor: state.cursor,
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(
        NotificationsError(
          cursor: state.cursor,
          message: 'Unexpected error: ${e.toString()}',
        ),
      );
    }
  }
}
