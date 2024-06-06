// abstract interface is force a class which must implement this one.
import 'package:blog/core/error/failures.dart';
import 'package:blog/core/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  // this is async, so using Future
  Future<Either<Failure, User>> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> currentUser();
}
