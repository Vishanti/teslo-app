// Tiene la implementacion de la definicion que tiene el datasource a utilizar

import 'package:teslo_app/features/auth/domain/domain.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String email, String password, String fullName);
  Future<UserEntity> checkAuthStatus(String token);
}
