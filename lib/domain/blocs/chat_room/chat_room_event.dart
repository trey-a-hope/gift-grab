part of 'chat_room_bloc.dart';

sealed class ChatRoomEvent {
  const ChatRoomEvent();
}

class ConnectToSocket extends ChatRoomEvent {
  final String room;

  ConnectToSocket(this.room);
}

class FetchMessages extends ChatRoomEvent {
  FetchMessages();
}

class MessageUpdate extends ChatRoomEvent {
  final String text;

  MessageUpdate(this.text);
}

class SendMessage extends ChatRoomEvent {
  final String text;
  SendMessage(this.text);
}
