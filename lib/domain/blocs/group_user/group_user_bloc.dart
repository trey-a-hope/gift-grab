import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:nakama/nakama.dart';

part 'group_user_event.dart';
part 'group_user_state.dart';

class GroupUserBloc extends Bloc<GroupUserEvent, GroupUserState> {
  GroupUserBloc() : super(GroupUserInitial()) {
    on<LoadGroupUsersEvent>(_onLoadGroupUsersEvent);
  }

  Future<void> _onLoadGroupUsersEvent(
    LoadGroupUsersEvent event,
    Emitter<GroupUserState> emit,
  ) async {
    emit(GroupUserLoading());

    try {
      final session = await NakamaService().getValidSession();

      if (session == null) {
        throw Exception('Session expired...');
      } else {
        final groupUserList = await getNakamaClient().listGroupUsers(
          session: session,
          groupId: event.groupId,
        );

        emit(GroupUsersLoaded(users: groupUserList.groupUsers));
      }
    } catch (e) {
      emit(GroupUsersError(message: e.toString()));
    }
  }
}
