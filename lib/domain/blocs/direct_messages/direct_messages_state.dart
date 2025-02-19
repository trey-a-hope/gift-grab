part of 'direct_messages_bloc.dart';

class DirectMessagesState {
  final String? cursor;

  DirectMessagesState({
    required this.cursor,
  });
}

class DirectMessagesInitial extends DirectMessagesState {
  DirectMessagesInitial({
    required super.cursor,
  });
}

class DirectMessagesLoading extends DirectMessagesState {
  DirectMessagesLoading({
    required super.cursor,
  });
}

class DirectMessagesLoaded extends DirectMessagesState {
  final List<String> directMessages;

  DirectMessagesLoaded({
    required this.directMessages,
    required super.cursor,
  });
}

class DirectMessagesSuccess extends DirectMessagesState {
  final String message;

  DirectMessagesSuccess({
    required this.message,
    required super.cursor,
  });
}

class DirectMessagesError extends DirectMessagesState {
  final String message;

  DirectMessagesError({
    required this.message,
    required super.cursor,
  });
}
