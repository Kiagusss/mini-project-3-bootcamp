part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final User? user;
  final bool isLoading;
  final String errorMessage;
  final bool isRegistering;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage = "",
    this.isRegistering = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
    bool? isRegistering,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isRegistering: isRegistering ?? this.isRegistering,
    );
  }

  @override
  List<Object?> get props => [user, isLoading, errorMessage, isRegistering];
}

class AuthSuccess extends AuthState {
  const AuthSuccess({required User? user, required bool isRegistering})
      : super(user: user, isRegistering: isRegistering);
}

class AuthFailure extends AuthState {
  const AuthFailure({required String errorMessage, required bool isRegistering})
      : super(errorMessage: errorMessage, isRegistering: isRegistering);
}
