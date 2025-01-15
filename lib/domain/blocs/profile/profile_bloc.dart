import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc authBloc;

  final _leaderboardName = 'weekly_leaderboard';
  final NakamaService _nakamaService;

  ProfileBloc({
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

      // TODO: Currently have an open issue for this problem...
      // https://github.com/heroiclabs/nakama-dart/issues/122
      final leaderboard =
          await getNakamaClient().listLeaderboardRecordsAroundOwner(
        session: session,
        leaderboardName: _leaderboardName,
        ownerId: account.user.id,
      );

      LeaderboardRecord? record;
      if (leaderboard.records != null && leaderboard.records!.isNotEmpty) {
        record = leaderboard.records!.first;
      }

      emit(
        ProfileLoaded(
          user: account.user,
          record: record,
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
