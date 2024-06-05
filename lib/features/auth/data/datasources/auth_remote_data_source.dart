import 'package:blog/core/error/exceptions.dart';
import 'package:blog/features/auth/data/models/user_model.dart';
import 'package:supabase/supabase.dart';

abstract interface class AuthRemoteSource {
  // this is diffrent from repo, this is only return String
  Future<UserModel> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  });
}

// 1h25
class AuthRemoteDataSourceImpl implements AuthRemoteSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<UserModel> loginWithEmail(
      {required String email, required String password}) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw ServerException('User is null!');
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'name': name},
      );
      if (response.user == null) {
        throw ServerException('User is null!');
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
