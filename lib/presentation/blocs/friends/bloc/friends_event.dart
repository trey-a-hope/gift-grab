part of 'friends_bloc.dart';

sealed class FriendsEvent {
  const FriendsEvent();
}

class Add extends FriendsEvent {
  final String uid;
  const Add(this.uid);
}

class Delete extends FriendsEvent {
  final String uid;
  const Delete(this.uid);
}

class Block extends FriendsEvent {
  final String uid;
  const Block(this.uid);
}
