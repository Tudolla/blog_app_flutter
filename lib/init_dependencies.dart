import 'package:blog/core/secrets/app_secret.dart';
import 'package:blog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog/features/auth/domain/repository/auth_repository.dart';
import 'package:blog/features/auth/domain/usecases/current_user.dart';
import 'package:blog/features/auth/domain/usecases/user_login.dart';
import 'package:blog/features/auth/domain/usecases/user_signup.dart';
import 'package:blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;
// 2h17.

Future<void> init_dependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseURL, anonKey: AppSecrets.apiKey);

  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  serviceLocator
      .registerFactory<AuthRemoteSource>(() => AuthRemoteDataSourceImpl(
            serviceLocator(),
          ));

  serviceLocator.registerFactory<AuthRepository>(() => AuthRepositoryImpl(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => UserSignup(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => UserLogin(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => CurrentUser(
        serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      currentUser: serviceLocator(),
    ),
  );
}
