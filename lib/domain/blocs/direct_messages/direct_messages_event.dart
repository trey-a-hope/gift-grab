part of 'direct_messages_bloc.dart';

sealed class DirectMessagesEvent {}

class FetchDirectMessages extends DirectMessagesEvent {}

class FetchMoreDirectMessages extends DirectMessagesEvent {}

class DeleteDirectMessage extends DirectMessagesEvent {
  final String id;

  DeleteDirectMessage({required this.id});
}
