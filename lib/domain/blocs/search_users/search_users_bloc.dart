import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_users_event.dart';
part 'search_users_state.dart';

class SearchUsersBloc extends Bloc<SearchUsersEvent, SearchUsersState> {
  final AuthBloc authBloc;
  final NakamaService _nakamaService;

  Timer? _debounceTimer;

  SearchUsersBloc({
    required this.authBloc,
  })  : _nakamaService = NakamaService(),
        super(SearchUsersLoaded(users: [], query: '')) {
    on<SearchUser>(
      _onSearchUser,
      transformer: debounce(
        const Duration(milliseconds: 300),
      ),
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounce(duration).switchMap(mapper);
  }

  Future<void> _onSearchUser(
    SearchUser event,
    Emitter<SearchUsersState> emit,
  ) async {
    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      final users = await getNakamaClient().getUsers(
        session: session,
        ids: [],
        usernames: [event.username],
      );

      emit(SearchUsersLoaded(
        users: users,
        query: event.username,
      ));
    } on GrpcError catch (e) {
      emit(
        SearchUsersError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          query: state.query,
        ),
      );
    } catch (e) {
      emit(
        SearchUsersError(
          message: 'Unexpected error: ${e.toString()}',
          query: state.query,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
