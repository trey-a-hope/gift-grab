part of 'chat_rooms_bloc.dart';

class ChatRoomsState {
  final List<String> rooms;
  const ChatRoomsState(this.rooms);
}

class ChatRoomsInitial extends ChatRoomsState {
  ChatRoomsInitial(super.rooms);
}

class ChatRoomsLoading extends ChatRoomsState {
  ChatRoomsLoading(super.rooms);
}

class ChatRoomsLoaded extends ChatRoomsState {
  final String? newChatRoomName;

  ChatRoomsLoaded({
    this.newChatRoomName,
    required List<String> rooms,
  }) : super(rooms);
}

class ChatRoomsSuccess extends ChatRoomsState {
  final String message;

  ChatRoomsSuccess({
    required this.message,
    required List<String> rooms,
  }) : super(rooms);
}

class ChatRoomsError extends ChatRoomsState {
  final String message;

  ChatRoomsError({
    required List<String> rooms,
    required this.message,
  }) : super(rooms);
}
