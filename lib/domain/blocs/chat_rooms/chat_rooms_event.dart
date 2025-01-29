part of 'chat_rooms_bloc.dart';

sealed class ChatRoomsEvent {
  const ChatRoomsEvent();
}

class FetchChatRooms extends ChatRoomsEvent {}
