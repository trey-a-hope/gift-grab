part of 'account_bloc.dart';

sealed class AccountEvent extends Equatable {
  const AccountEvent();
}

class ReadAccount extends AccountEvent {
  const ReadAccount();

  @override
  List<Object?> get props => [];
}

class UpdateAccount extends AccountEvent {
  final String username;

  const UpdateAccount({required this.username});

  @override
  List<Object?> get props => [username];
}

class DeleteAccount extends AccountEvent {
  const DeleteAccount();

  @override
  List<Object?> get props => [];
}

class LinkEmail extends AccountEvent {
  final String email;
  final String password;

  const LinkEmail({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class UnlinkEmail extends AccountEvent {
  const UnlinkEmail();

  @override
  List<Object?> get props => [];
}

class LinkGoogle extends AccountEvent {
  const LinkGoogle();

  @override
  List<Object?> get props => [];
}

class UnlinkGoogle extends AccountEvent {
  const UnlinkGoogle();

  @override
  List<Object?> get props => [];
}

class LinkApple extends AccountEvent {
  const LinkApple();

  @override
  List<Object?> get props => [];
}

class UnlinkApple extends AccountEvent {
  const UnlinkApple();

  @override
  List<Object?> get props => [];
}
