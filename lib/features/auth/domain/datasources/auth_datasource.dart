// La definicion de como quiero que sea todos los sistema de auth que maneja la app, para un futuro cambiarlo facilmente

import 'package:teslo_app/features/auth/domain/domain.dart';

abstract class AuthDataSource {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String email, String password, String fullName);
  Future<UserEntity> checkAuthStatus(String token);
}
