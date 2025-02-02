part of 'chat_room_bloc.dart';

class ChatRoomState {
  final Channel? channel;
  final List<ChannelMessage> messages;
  final String text;

  const ChatRoomState(
    this.channel,
    this.messages,
    this.text,
  );
}

class ChatRoomInitial extends ChatRoomState {
  ChatRoomInitial(
    super.channel,
    super.messages,
    super.text,
  );
}

class ChatRoomLoading extends ChatRoomState {
  ChatRoomLoading(
    super.channel,
    super.messages,
    super.text,
  );
}

class ChatRoomLoaded extends ChatRoomState {
  ChatRoomLoaded(
    super.channel,
    super.messages,
    super.text,
  );
}

class ChatRoomSuccess extends ChatRoomState {
  final String message;

  ChatRoomSuccess({
    required Channel? channel,
    required List<ChannelMessage> messages,
    required String text,
    required this.message,
  }) : super(
          channel,
          messages,
          text,
        );
}

class ChatRoomError extends ChatRoomState {
  final String message;

  ChatRoomError({
    required Channel? channel,
    required List<ChannelMessage> messages,
    required String text,
    required this.message,
  }) : super(
          channel,
          messages,
          text,
        );
}
