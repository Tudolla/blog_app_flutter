import 'package:blog/core/error/exceptions.dart';
import 'package:blog/features/auth/data/models/user_model.dart';
import 'package:supabase/supabase.dart';

abstract interface class AuthRemoteSource {
  Session? get currentUserSession;
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
  Future<UserModel?> getCurrentUserData();
}

// 1h25
class AuthRemoteDataSourceImpl implements AuthRemoteSource {
  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

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
        throw const ServerException('User is null!');
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
        throw const ServerException('User is null!');
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);

        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
        );
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
