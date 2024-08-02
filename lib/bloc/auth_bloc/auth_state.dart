part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User? user;
  final bool isRegistering;

  const AuthSuccess({required this.user, required this.isRegistering});

  @override
  List<Object?> get props => [user, isRegistering];
}

class AuthFailure extends AuthState {
  final bool isRegistering;
  final String errorMessage;

  const AuthFailure({required this.isRegistering, required this.errorMessage});

  @override
  List<Object?> get props => [isRegistering, errorMessage];
}
