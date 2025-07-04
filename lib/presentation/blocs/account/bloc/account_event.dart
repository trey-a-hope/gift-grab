part of 'account_bloc.dart';

sealed class AccountEvent extends Equatable {}

class ReadAccount extends AccountEvent {
  @override
  List<Object?> get props => [];
}

class UpdateAccount extends AccountEvent {
  final String username;

  UpdateAccount({required this.username});

  @override
  List<Object?> get props => [username];
}

class DeleteAccount extends AccountEvent {
  @override
  List<Object?> get props => [];
}

class LinkEmailAccount extends AccountEvent {
  final String email;
  final String password;

  LinkEmailAccount({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class UnlinkEmailAccount extends AccountEvent {
  @override
  List<Object?> get props => [];
}

class LinkGoogleAccount extends AccountEvent {
  @override
  List<Object?> get props => [];
}

class UnlinkGoogleAccount extends AccountEvent {
  @override
  List<Object?> get props => [];
}

class LinkAppleAccount extends AccountEvent {
  @override
  List<Object?> get props => [];
}

class UnlinkAppleAccount extends AccountEvent {
  @override
  List<Object?> get props => [];
}
