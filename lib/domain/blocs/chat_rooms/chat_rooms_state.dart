part of 'chat_rooms_bloc.dart';

class ChatRoomsState {
  const ChatRoomsState();
}

class ChatRoomsInitial extends ChatRoomsState {}

class ChatRoomsLoading extends ChatRoomsState {}

class ChatRoomsLoaded extends ChatRoomsState {
  final List<String> chatRooms;

  ChatRoomsLoaded({
    required this.chatRooms,
  });
}

class ChatRoomsSuccess extends ChatRoomsState {
  final String message;

  ChatRoomsSuccess({
    required this.message,
  });
}

class ChatRoomsError extends ChatRoomsState {
  final String message;

  ChatRoomsError({
    required this.message,
  });
}
