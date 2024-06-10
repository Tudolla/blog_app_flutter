import 'package:blog/core/error/exceptions.dart';
import 'package:blog/core/error/failures.dart';
import 'package:blog/core/network/connection_check.dart';
import 'package:blog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog/core/entities/user.dart';
import 'package:blog/features/auth/data/models/user_model.dart';
import 'package:blog/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource remoteDataSource;
  final ConnectionCheck connectionCheck;

  AuthRepositoryImpl(this.remoteDataSource, this.connectionCheck);

  @override
  Future<Either<Failure, User>> loginWithEmail(
      {required String email, required String password}) async {
    try {
      if (!await (connectionCheck.isConnected)) {
        return left(Failure('Please check the internet connection !'));
      }
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
      if (!await (connectionCheck.isConnected)) {
        return left(Failure('Please check the internet connection !'));
      }
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
      if (!await (connectionCheck.isConnected)) {
        final session = remoteDataSource.currentUserSession;
        if (session == null) {
          return left(Failure('User isn\'t logged in'));
        }

        return right(UserModel(
          id: session.user.id,
          name: '',
          email: session.user.email ?? '',
        ));
      }

      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure("User isn't logged in"));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
