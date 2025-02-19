import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/data/services/storage/base_storage_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:grpc/grpc.dart';

part 'direct_messages_event.dart';
part 'direct_messages_state.dart';

class DirectMessagesBloc
    extends Bloc<DirectMessagesEvent, DirectMessagesState> {
  final AuthBloc authBloc;
  final NakamaService _nakamaService;
  late DirectChatStorage _directChatStorage;

  DirectMessagesBloc({
    required this.authBloc,
  })  : _nakamaService = NakamaService(),
        super(DirectMessagesInitial(cursor: null)) {
    on<FetchDirectMessages>(_onFetchDirectMessages);
    on<FetchMoreDirectMessages>(_onFetchMoreDirectMessages);
    on<DeleteDirectMessage>(_onDeleteDirectMessage);
  }

  Future<void> _onFetchDirectMessages(
    FetchDirectMessages event,
    Emitter<DirectMessagesState> emit,
  ) async {
    emit(DirectMessagesLoading(cursor: state.cursor));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);
      _directChatStorage = DirectChatStorage(uid: session.userId);
      final ids = await _directChatStorage.getValue(session, null);

      emit(
        DirectMessagesLoaded(
          directMessages: ids,
          cursor: null,
        ),
      );
    } on GrpcError catch (e) {
      emit(
        DirectMessagesError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          cursor: state.cursor,
        ),
      );
    } catch (e) {
      emit(
        DirectMessagesError(
          message: 'Unexpected error: ${e.toString()}',
          cursor: state.cursor,
        ),
      );
    }
  }

  Future<void> _onFetchMoreDirectMessages(
    FetchMoreDirectMessages event,
    Emitter<DirectMessagesState> emit,
  ) async {
    emit(DirectMessagesLoading(cursor: state.cursor));

    try {
      // final response = await _nakamaService.fetchDirectMessages(cursor: state.cursor);
      // final directMessages = response.directMessages;
      // final cursor = response.cursor;

      // if (state is DirectMessagesLoaded) {
      //   final currentState = state as DirectMessagesLoaded;
      //   emit(
      //     DirectMessagesLoaded(
      //       directMessages: [...currentState.directMessages, ...<String>[]],
      //       cursor: null,
      //     ),
      //   );
      // }
      throw UnimplementedError();
    } on GrpcError catch (e) {
      emit(
        DirectMessagesError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          cursor: state.cursor,
        ),
      );
    } catch (e) {
      emit(
        DirectMessagesError(
          message: 'Unexpected error: ${e.toString()}',
          cursor: state.cursor,
        ),
      );
    }
  }

  Future<void> _onDeleteDirectMessage(
    DeleteDirectMessage event,
    Emitter<DirectMessagesState> emit,
  ) async {
    emit(DirectMessagesLoading(cursor: state.cursor));

    try {
      // await _nakamaService.deleteDirectMessage(event.id);

      //
      // emit(
      //   DirectMessagesSuccess(
      //     message: 'DirectMessage deleted successfully',
      //     cursor: state.cursor,
      //   ),
      // );
      //
      //
      throw UnimplementedError();
    } on GrpcError catch (e) {
      emit(
        DirectMessagesError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          cursor: state.cursor,
        ),
      );
    } catch (e) {
      emit(
        DirectMessagesError(
          message: 'Unexpected error: ${e.toString()}',
          cursor: state.cursor,
        ),
      );
    }
  }
}
