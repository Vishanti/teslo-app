import 'package:teslo_app/features/auth/domain/domain.dart';
import 'package:teslo_app/features/auth/infrastructure/infrastructure.dart';

// Implementacion del repository

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({AuthDataSource? dataSource})
      : dataSource = dataSource ?? AuthDataSourceImpl();

  @override
  Future<UserEntity> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<UserEntity> login(String email, String password) {
    return dataSource.login(email, password);
  }

  @override
  Future<UserEntity> register(String email, String password, String fullName) {
    return dataSource.register(email, password, fullName);
  }
}
