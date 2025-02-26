
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthRegister extends AuthEvent {
  final String email;
  final String password;
  final String username;

  const AuthRegister({required this.email, required this.password, required this.username});

  @override
  List<Object?> get props => [email, password, username];
}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthLogin({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthLogout extends AuthEvent {}

class AuthCheckStatus extends AuthEvent {}