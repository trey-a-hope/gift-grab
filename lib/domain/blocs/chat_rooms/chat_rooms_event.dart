part of 'chat_rooms_bloc.dart';

sealed class ChatRoomsEvent {
  const ChatRoomsEvent();
}

class FetchChatRooms extends ChatRoomsEvent {}

class ChatRoomNameChange extends ChatRoomsEvent {
  final String name;

  ChatRoomNameChange({
    required this.name,
  });
}

class SaveChatRoom extends ChatRoomsEvent {
  final String name;

  SaveChatRoom({required this.name});
}
