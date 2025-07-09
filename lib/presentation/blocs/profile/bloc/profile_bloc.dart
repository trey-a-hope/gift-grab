import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab/presentation/blocs/account/bloc/account_bloc.dart';
import 'package:gift_grab/presentation/utils/bloc_handler.dart';
import 'package:nakama/nakama.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final String uid;
  final AccountBloc accountBloc;
  final SessionService sessionService;
  final NakamaBaseClient nakamaBaseClient;

  ProfileBloc(
    this.sessionService,
    this.uid,
    this.accountBloc,
    this.nakamaBaseClient,
  ) : super(ProfileState()) {
    on<ReadProfile>(_onReadProfile);
  }

  Future<void> _onReadProfile(
    ReadProfile event,
    Emitter<ProfileState> emit,
  ) async =>
      await BlocHandler<ProfileState>().handle(
          action: () async {
            emit(state.copyWith(isLoading: true));

            final session = (await sessionService.getSession());

            final account = accountBloc.state.account!;

            final users = (await nakamaBaseClient.getUsers(
              session: session,
              ids: [uid],
            ));

            final user = users.first;

            final isMyProfile = account.user.id == user.id;

            emit(
              state.copyWith(
                user: user,
                isMyProfile: isMyProfile,
              ),
            );
          },
          emit: emit,
          state: state);
}
