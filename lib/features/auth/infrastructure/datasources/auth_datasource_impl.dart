import 'package:dio/dio.dart';
import 'package:teslo_app/config/config.dart';
import 'package:teslo_app/features/auth/domain/domain.dart';
import 'package:teslo_app/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_app/features/auth/infrastructure/mappers/user_mapper.dart';

// Implementacion del datasource

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
    ),
  );

  @override
  Future<UserEntity> checkAuthStatus(String token) async {
    try {
      final response = await dio.get(
        '/auth/check-status',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw CustomErrorMessage('Token Invalid', 401);
      if (e.type == DioExceptionType.connectionError) throw ConnectionTimeout();
      throw CustomErrorMessage('Something wrong happend', 500);
    } catch (e) {
      throw CustomErrorMessage('Something wrong happend', 500);
    }
  }

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final response = await dio
          .post('/auth/login', data: {'email': email, 'password': password});

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw WrongCredentials();
      if (e.type == DioExceptionType.connectionError) throw ConnectionTimeout();
      throw CustomErrorMessage('Something wrong happend', 500);
    } catch (e) {
      throw CustomErrorMessage('Something wrong happend', 500);
    }
  }

  @override
  Future<UserEntity> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
