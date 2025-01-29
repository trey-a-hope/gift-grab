import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:grpc/grpc.dart';

part 'chat_rooms_event.dart';
part 'chat_rooms_state.dart';

class ChatRoomsBloc extends Bloc<ChatRoomsEvent, ChatRoomsState> {
  final AuthBloc authBloc;
  final NakamaService _nakamaService;

  ChatRoomsBloc({
    required this.authBloc,
  })  : _nakamaService = NakamaService(),
        super(const ChatRoomsState()) {
    on<FetchChatRooms>(_onFetchChatRooms);
  }

  Future<void> _onFetchChatRooms(
    FetchChatRooms event,
    Emitter<ChatRoomsState> emit,
  ) async {
    emit(ChatRoomsLoading());

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);
      if (session == null) return;

      final rooms = [
        'Marvel Comics',
        'Jurrasic Park',
        'Good Fellas',
      ];

      emit(
        ChatRoomsLoaded(
          chatRooms: rooms,
        ),
      );
    } on GrpcError catch (e) {
      emit(
        ChatRoomsError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
        ),
      );
    } catch (e) {
      emit(
        ChatRoomsError(
          message: 'Unexpected error: ${e.toString()}',
        ),
      );
    }
  }
}
