import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/data/services/storage/base_storage_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:grpc/grpc.dart';

part 'chat_rooms_event.dart';
part 'chat_rooms_state.dart';

class ChatRoomsBloc extends Bloc<ChatRoomsEvent, ChatRoomsState> {
  final AuthBloc authBloc;
  final NakamaService _nakamaService;
  final ChatStorage _chatStorage;

  ChatRoomsBloc({
    required this.authBloc,
  })  : _nakamaService = NakamaService(),
        _chatStorage = ChatStorage(),
        super(const ChatRoomsState([])) {
    on<FetchChatRooms>(_onFetchChatRooms);
    on<ChatRoomNameChange>(_onChatRoomNameChange);
    on<SaveChatRoom>(_onSaveChatRoom);
  }

  Future<void> _onFetchChatRooms(
    FetchChatRooms event,
    Emitter<ChatRoomsState> emit,
  ) async {
    emit(ChatRoomsLoading(state.rooms));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      final rooms = await _chatStorage.getValue(session, null);

      emit(
        ChatRoomsLoaded(
          rooms: rooms,
        ),
      );
    } on GrpcError catch (e) {
      emit(
        ChatRoomsError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          rooms: state.rooms,
        ),
      );
    } catch (e) {
      emit(
        ChatRoomsError(
          message: 'Unexpected error: ${e.toString()}',
          rooms: state.rooms,
        ),
      );
    }
  }

  Future<void> _onChatRoomNameChange(
    ChatRoomNameChange event,
    Emitter<ChatRoomsState> emit,
  ) async {
    emit(ChatRoomsLoading(state.rooms));

    try {
      emit(
        ChatRoomsLoaded(
          rooms: state.rooms,
          newChatRoomName: event.name,
        ),
      );
    } on GrpcError catch (e) {
      emit(
        ChatRoomsError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          rooms: state.rooms,
        ),
      );
    } catch (e) {
      emit(
        ChatRoomsError(
          message: 'Unexpected error: ${e.toString()}',
          rooms: state.rooms,
        ),
      );
    }
  }

  Future<void> _onSaveChatRoom(
    SaveChatRoom event,
    Emitter<ChatRoomsState> emit,
  ) async {
    emit(ChatRoomsLoading(state.rooms));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      final rooms = state.rooms;
      await _chatStorage.updateValue(
        session,
        [...rooms, event.name],
      );

      emit(
        ChatRoomsSuccess(
            message: 'Chat room created successfully', rooms: rooms),
      );
    } on GrpcError catch (e) {
      emit(
        ChatRoomsError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          rooms: state.rooms,
        ),
      );
    } catch (e) {
      emit(
        ChatRoomsError(
          message: 'Unexpected error: ${e.toString()}',
          rooms: state.rooms,
        ),
      );
    }
  }
}
