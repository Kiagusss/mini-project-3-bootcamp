import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    monitorAuthState();

    on<AuthRegister>((event, emit) async {
      emit(state.copyWith(isLoading: true, isRegistering: true));

      try {
        final res = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        emit(AuthSuccess(user: res.user, isRegistering: true));
      } catch (e) {
        emit(AuthFailure(errorMessage: e.toString(), isRegistering: true));
      }
    });

    on<AuthLogin>((event, emit) async {
      emit(state.copyWith(isLoading: true, isRegistering: false));

      try {
        final res = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        emit(AuthSuccess(user: res.user, isRegistering: false));
      } catch (e) {
        emit(AuthFailure(errorMessage: e.toString(), isRegistering: false));
      }
    });
  }

  void monitorAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        add(AuthUpdated(userData: user));
      }
    });
  }
}
