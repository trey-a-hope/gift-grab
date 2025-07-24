import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_error_handler/bloc_error_handler.dart';
import 'package:equatable/equatable.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:nakama/nakama.dart';

part 'search_users_event.dart';
part 'search_users_state.dart';

class SearchUsersBloc extends Bloc<SearchUsersEvent, SearchUsersState> {
  final SessionService sessionService;

  SearchUsersBloc(this.sessionService) : super(const SearchUsersState()) {
    on<SearchUser>(_onSearchUser);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onSearchUser(
    SearchUser event,
    Emitter<SearchUsersState> emit,
  ) async =>
      await runWithErrorHandling<SearchUsersState>(
        action: () async {
          emit(state.copyWith(isLoading: true));

          final session = await sessionService.getSession();

          final users = await getNakamaClient().getUsers(
            session: session,
            ids: [],
            usernames: [event.username],
          );

          emit(state.copyWith(
            query: event.username,
            users: users,
          ));
        },
        emit: emit,
        state: state,
      );

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<SearchUsersState> emit,
  ) async =>
      emit(
        state.copyWith(
          query: '',
          users: [],
        ),
      );
}
