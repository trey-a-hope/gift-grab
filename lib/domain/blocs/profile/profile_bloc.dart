import 'dart:async';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/data/services/storage/base_storage_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/presentation/models/leaderboard_entry.dart';
import 'package:grpc/grpc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nakama/nakama.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc authBloc;
  final String uid;

  final _leaderboardName = 'weekly_leaderboard';

  final NakamaService _nakamaService;
  final GamesPlayedStorage _gamesPlayedStorage;

  ProfileBloc({
    required this.uid,
    required this.authBloc,
  })  : _nakamaService = NakamaService(),
        _gamesPlayedStorage = GamesPlayedStorage(),
        super(ProfileInitial()) {
    on<FetchProfile>(_onFetchProfile);
    on<DeleteRecord>(_onDeleteRecord);
    on<AddFriend>(_onAddFriend);
    on<UploadPhoto>(_onUploadPhoto);
  }

  Future<void> _onFetchProfile(
    FetchProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      final account = await getNakamaClient().getAccount(session);

      final user =
          (await getNakamaClient().getUsers(session: session, ids: [uid]))
              .first;

      final isMyProfile = account.user.id == user.id;

      // TODO: See if user is my friend already.

      final gamesPlayed = await _gamesPlayedStorage.getValue(session, uid);

      final tournamentRecordList =
          await getNakamaClient().listTournamentRecordsAroundOwner(
        session: session,
        tournamentId: 'daily_tournament',
        ownerId: user.id,
      );

      final entries = tournamentRecordList.records
          .map((record) => LeaderboardEntry(record: record, user: user))
          .toList();

      emit(
        ProfileLoaded(
          user: user,
          isMyProfile: isMyProfile,
          gamesPlayed: gamesPlayed,
          tournamentEntries: entries,
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

      await getNakamaClient().deleteLeaderboardRecord(
        session: session,
        leaderboardName: _leaderboardName,
      );

      emit(
        ProfileSuccess(message: 'Record deleted successfully'),
      );
    } on GrpcError catch (e) {
      emit(ProfileError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(ProfileError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onAddFriend(
    AddFriend event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      await getNakamaClient().addFriends(
        session: session,
        ids: [event.uid],
      );

      emit(
        ProfileSuccess(message: 'Request sent successfully'),
      );
    } on GrpcError catch (e) {
      emit(ProfileError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } catch (e) {
      emit(ProfileError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onUploadPhoto(
    UploadPhoto event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (image == null) {
        add(FetchProfile());
        return;
      }

      final response = await Globals.cloudinaryConfig.upload(
        file: image.path,
        fileBytes: await image.readAsBytes(),
        resourceType: CloudinaryResourceType.image,
        folder: 'gift_grab/avatars',
        fileName: uid,
      );

      if (!response.isSuccessful) {
        throw Exception('Upload was unsuccessful for some reason...');
      }

      await getNakamaClient().updateAccount(
        session: session,
        avatarUrl: response.secureUrl,
      );

      emit(
        ProfileSuccess(message: 'Avatar updated successfully'),
      );
    } on GrpcError catch (e) {
      emit(ProfileError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}'));
    } on PlatformException catch (e) {
      emit(ProfileError(
          message:
              e.message ?? 'Unknown PlatformException Error: ${e.message}'));
    } catch (e) {
      emit(ProfileError(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
