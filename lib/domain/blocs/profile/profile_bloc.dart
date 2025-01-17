import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc authBloc;
  final String uid;

  final _leaderboardName = 'weekly_leaderboard';
  final NakamaService _nakamaService;

  ProfileBloc({
    required this.uid,
    required this.authBloc,
  })  : _nakamaService = NakamaService(),
        super(ProfileInitial()) {
    on<FetchProfile>(_onFetchProfile);
    on<DeleteRecord>(_onDeleteRecord);
  }

  Future<void> _onFetchProfile(
    FetchProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);
      if (session == null) return;

      final account = await getNakamaClient().getAccount(session);

      final user =
          (await getNakamaClient().getUsers(session: session, ids: [uid]))
              .first;

      final isMyProfile = account.user.id == user.id;

      // TODO: https://github.com/heroiclabs/nakama-dart/issues/122
      final leaderboard =
          await getNakamaClient().listLeaderboardRecordsAroundOwner(
        session: session,
        leaderboardName: _leaderboardName,
        ownerId: user.id,
      );

      LeaderboardRecord? record;
      if (leaderboard.records != null && leaderboard.records!.isNotEmpty) {
        record = leaderboard.records!.first;
      }

      emit(
        ProfileLoaded(
          user: account.user,
          record: record,
          isMyProfile: isMyProfile,
        ),
      );
    } on GrpcError catch (e) {
      emit(ProfileError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(ProfileError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteRecord(
    DeleteRecord event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);
      if (session == null) return;

      await getNakamaClient().deleteLeaderboardRecord(
        session: session,
        leaderboardName: _leaderboardName,
      );

      emit(
        ProfileActionSuccess(message: 'Record deleted successfully'),
      );
    } on GrpcError catch (e) {
      emit(ProfileError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(ProfileError(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
