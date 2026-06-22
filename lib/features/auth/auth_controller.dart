import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/safezone_models.dart';
import '../../data/providers.dart';

class AuthState {
  const AuthState({
    this.user,
    this.loading = false,
    this.error,
  });

  final SafeZoneUser? user;
  final bool loading;
  final String? error;

  bool get authenticated => user != null;

  AuthState copyWith({
    SafeZoneUser? user,
    bool? loading,
    String? error,
    bool clearUser = false,
    bool clearError = false,
  }) =>
      AuthState(
        user: clearUser ? null : user ?? this.user,
        loading: loading ?? this.loading,
        error: clearError ? null : error ?? this.error,
      );
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._ref) : super(const AuthState());

  final Ref _ref;

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final user =
          await _ref.read(repositoryProvider).login(email.trim(), password);
      state = AuthState(user: user);
    } catch (error) {
      state =
          AuthState(error: error.toString().replaceFirst('Bad state: ', ''));
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final user = await _ref
          .read(repositoryProvider)
          .register(name.trim(), email.trim(), password);
      state = AuthState(user: user);
    } catch (error) {
      state =
          AuthState(error: error.toString().replaceFirst('Bad state: ', ''));
    }
  }

  Future<void> logout() async {
    await _ref.read(repositoryProvider).logout();
    state = const AuthState();
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});
