import 'package:blog/core/error/exceptions.dart';
import 'package:blog/core/error/failures.dart';
import 'package:blog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog/core/entities/user.dart';
import 'package:blog/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> loginWithEmail(
      {required String email, required String password}) async {
    try {
      final user = await remoteDataSource.loginWithEmail(
          email: email, password: password);

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmail(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final user = await remoteDataSource.signUpWithEmail(
          name: name, email: email, password: password);

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure("User is not logged in"));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
