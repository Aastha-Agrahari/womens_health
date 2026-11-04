import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_repository.dart';

class AuthState extends Equatable {
  final bool loading;
  final bool otpSent;
  final bool authenticated;
  final String? error;

  const AuthState({
    this.loading = false,
    this.otpSent = false,
    this.authenticated = false,
    this.error,
  });

  AuthState copyWith({
    bool? loading,
    bool? otpSent,
    bool? authenticated,
    String? error,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      otpSent: otpSent ?? this.otpSent,
      authenticated: authenticated ?? this.authenticated,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, otpSent, authenticated, error];
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repo;
  AuthCubit(this.repo) : super(const AuthState());

  Future<void> sendOtp(String phone) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      await repo.requestOtp(phone);
      emit(state.copyWith(loading: false, otpSent: true));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> verify(String phone, String otp) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      await repo.verifyOtp(phone, otp);
      emit(state.copyWith(loading: false, authenticated: true));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  // FIX: added logout() used by ProfilePage
  Future<void> logout() async {
    await repo.logout();
    emit(const AuthState());
  }
}