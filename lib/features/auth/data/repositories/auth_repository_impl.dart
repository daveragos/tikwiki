import 'package:injectable/injectable.dart';
import 'package:tikwiki/core/error/app_error_parser.dart';
import 'package:tikwiki/core/error/result.dart';
import 'package:tikwiki/features/auth/data/models/user_model.dart';
import 'package:tikwiki/features/auth/domain/entities/user_entity.dart';

import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  UserEntity? get currentUser {
    final user = _remoteDataSource.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  @override
  Stream<UserEntity?> get authStateChanges => _remoteDataSource.authStateChanges
      .map((user) => user != null ? UserModel.fromFirebaseUser(user) : null);

  @override
  Future<Result<UserEntity?>> getCurrentUser() async {
    try {
      final user = _remoteDataSource.currentUser;
      final entity = user != null ? UserModel.fromFirebaseUser(user) : null;
      return Success(entity);
    } catch (e, stackTrace) {
      return Failure(AppErrorParser.parse(e, stackTrace));
    }
  }

  @override
  Future<Result<UserEntity>> signInWithGoogle() async {
    try {
      final credential = await _remoteDataSource.signInWithGoogle();
      final user = credential.user;
      if (user == null) {
        throw Exception(
          'User was null after Google sign in credential creation.',
        );
      }
      await _remoteDataSource.syncUserProfile(user);
      return Success(UserModel.fromFirebaseUser(user));
    } catch (e, stackTrace) {
      return Failure(AppErrorParser.parse(e, stackTrace));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Success(null);
    } catch (e, stackTrace) {
      return Failure(AppErrorParser.parse(e, stackTrace));
    }
  }
}
