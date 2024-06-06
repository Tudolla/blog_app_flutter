// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blog/core/entities/user.dart';
import 'package:blog/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

import 'package:blog/core/error/failures.dart';
import 'package:blog/core/usecase/usecase.dart';

class UserSignup implements UseCase<User, UserSignupParam> {
  final AuthRepository authRepository;

  const UserSignup(this.authRepository);
  @override
  Future<Either<Failure, User>> call(UserSignupParam param) async {
    return await authRepository.signUpWithEmail(
        name: param.name, email: param.email, password: param.password);
  }
}

class UserSignupParam {
  final String name;
  final String email;
  final String password;
  UserSignupParam({
    required this.name,
    required this.email,
    required this.password,
  });
}
