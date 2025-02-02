part of 'chat_room_bloc.dart';

class ChatRoomState {
  final types.User? user;
  final Channel? channel;
  final List<ChannelMessage> messages;

  const ChatRoomState(
    this.user,
    this.channel,
    this.messages,
  );
}

class ChatRoomInitial extends ChatRoomState {
  ChatRoomInitial(
    super.user,
    super.channel,
    super.messages,
  );
}

class ChatRoomLoading extends ChatRoomState {
  ChatRoomLoading(
    super.user,
    super.channel,
    super.messages,
  );
}

class ChatRoomLoaded extends ChatRoomState {
  ChatRoomLoaded(
    super.user,
    super.channel,
    super.messages,
  );
}

class ChatRoomSuccess extends ChatRoomState {
  final String message;

  ChatRoomSuccess({
    required Channel? channel,
    required List<ChannelMessage> messages,
    required this.message,
    required types.User user,
  }) : super(
          user,
          channel,
          messages,
        );
}

class ChatRoomError extends ChatRoomState {
  final String message;

  ChatRoomError({
    required Channel? channel,
    required List<ChannelMessage> messages,
    required this.message,
    required types.User? user,
  }) : super(
          user,
          channel,
          messages,
        );
}
