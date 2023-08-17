// Mantender el estado del auth

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/features/auth/domain/domain.dart';
import 'package:teslo_app/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:teslo_app/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:teslo_app/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:teslo_app/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final UserEntity? user;
  final String errorMessage;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = ''});

  AuthState copyWith(
          {AuthStatus? authStatus, UserEntity? user, String? errorMessage}) =>
      AuthState(
          authStatus: authStatus ?? this.authStatus,
          user: user ?? this.user,
          errorMessage: errorMessage ?? this.errorMessage);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier(
      {required this.authRepository, required this.keyValueStorageService})
      : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on WrongCredentials {
      logout('Crendenciales no son correctas');
    } on ConnectionTimeout {
      logout('Timeout');
    } catch (e) {
      logout('Error no controlado');
    }
  }

  void registerUser(String email, String password, String fullName) async {}

  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    if (token == null) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  void _setLoggedUser(UserEntity user) async {
    await keyValueStorageService.setKeyValue('token', user.token);

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorageService.removeKey('token');

    state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
      authRepository: authRepository,
      keyValueStorageService: keyValueStorageService);
});
