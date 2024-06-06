import 'package:blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog/core/usecase/usecase.dart';
import 'package:blog/core/entities/user.dart';
import 'package:blog/features/auth/domain/usecases/current_user.dart';
import 'package:blog/features/auth/domain/usecases/user_login.dart';
import 'package:blog/features/auth/domain/usecases/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

// read back
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _userSignup;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignup userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignup = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  void _isUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser(NoParams());

    res.fold((l) => emit(AuthFailure(l.message)), (r) {
      print(r.email);
      emit(AuthSuccess(r));
    });
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignup(UserSignupParam(
        name: event.name, email: event.email, password: event.password));

    res.fold(
        (l) => emit(AuthFailure(l.message)), (user) => emit(AuthSuccess(user)));
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final res = await _userLogin(
        UserLoginParams(email: event.email, password: event.password));

    res.fold(
        (l) => emit(AuthFailure(l.message)), (user) => emit(AuthSuccess(user)));
  }
}
