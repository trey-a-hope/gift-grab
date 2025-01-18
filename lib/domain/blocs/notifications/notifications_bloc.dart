import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final AuthBloc authBloc;
  final NakamaService _nakamaService;

  NotificationsBloc({
    required this.authBloc,
  })  : _nakamaService = NakamaService(),
        super(NotificationsInitial(cursor: null)) {
    on<FetchNotifications>(_onFetchNotifications);
    on<FetchMoreNotifications>(_onFetchMoreNotifications);
    on<AcceptFriendRequest>(_onAcceptFriendRequest);
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

  Future<void> _onAcceptFriendRequest(
    AcceptFriendRequest event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading(cursor: state.cursor));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);
      if (session == null) return;

      await getNakamaClient().addFriends(
        session: session,
        ids: [],
        usernames: [event.username],
      );

      emit(
        NotificationsSuccess(
          message: 'Friend request accepted',
          cursor: state.cursor,
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
}
