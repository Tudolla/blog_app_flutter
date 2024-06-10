import 'package:blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog/core/network/connection_check.dart';
import 'package:blog/core/secrets/app_secret.dart';
import 'package:blog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog/features/auth/domain/repository/auth_repository.dart';
import 'package:blog/features/auth/domain/usecases/current_user.dart';
import 'package:blog/features/auth/domain/usecases/user_login.dart';
import 'package:blog/features/auth/domain/usecases/user_signup.dart';
import 'package:blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog/features/blog/data/datasources/blog_local_datasource.dart';
import 'package:blog/features/blog/data/datasources/blog_remote_datasource.dart';
import 'package:blog/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:blog/features/blog/domain/repositories/blog_repository.dart';
import 'package:blog/features/blog/domain/usecases/get__all_blogs.dart';
import 'package:blog/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;
// 2h17.

Future<void> init_dependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseURL, anonKey: AppSecrets.apiKey);

  Hive.defaultDirectory = (await getApplicationCacheDirectory()).path;
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));
  serviceLocator.registerFactory(() => InternetConnection());

  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  serviceLocator.registerFactory<ConnectionCheck>(
      () => ConnectionCheckImpl(serviceLocator()));
}

void _initAuth() {
  serviceLocator
      .registerFactory<AuthRemoteSource>(() => AuthRemoteDataSourceImpl(
            serviceLocator(),
          ));

  serviceLocator.registerFactory<BlogLocalDataSource>(
      () => BlogLocalDatasourceImpl(serviceLocator()));

  serviceLocator.registerFactory<AuthRepository>(() => AuthRepositoryImpl(
        serviceLocator(),
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
      appUserCubit: serviceLocator(),
    ),
  );
}

void _initBlog() {
  // Datasource
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDatasourceImpl(
        serviceLocator(),
      ),
    )
    //Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(), // box

        serviceLocator(), // checker internet
      ),
    )
    //Usecase
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(() => GetAllBlogs(
          serviceLocator(),
        ))
    //Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlog: serviceLocator(),
      ),
    );
}
