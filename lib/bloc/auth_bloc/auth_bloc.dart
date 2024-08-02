import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_project_3_bootcamp/services/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthRegister>(_onRegister);
    on<AuthLogin>(_onLogin);
    on<AuthLogout>(_onLogout);
    on<AuthCheckStatus>(_onCheckStatus);
  }

  Future<void> _onRegister(AuthRegister event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      User? user = await authRepository.register(
        email: event.email,
        password: event.password,
        username: event.username,
      );
      emit(AuthSuccess(user: user, isRegistering: true));
    } catch (e) {
      emit(AuthFailure(isRegistering: true, errorMessage: e.toString()));
    }
  }

  Future<void> _onLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      User? user = await authRepository.login(event.email, event.password);
      emit(AuthSuccess(user: user, isRegistering: false));
    } catch (e) {
      emit(AuthFailure(isRegistering: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLogout(AuthLogout event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(isRegistering: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onCheckStatus(AuthCheckStatus event, Emitter<AuthState> emit) async {
    User? user = await authRepository.getCurrentUser();
    if (user != null) {
      emit(AuthSuccess(user: user, isRegistering: false));
    } else {
      emit(AuthInitial());
    }
  }
}
