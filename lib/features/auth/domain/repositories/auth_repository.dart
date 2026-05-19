import 'package:tikwiki/core/error/result.dart';
import 'package:tikwiki/features/auth/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  UserEntity? get currentUser;

  Stream<UserEntity?> get authStateChanges;

  Future<Result<UserEntity?>> getCurrentUser();

  Future<Result<UserEntity>> signInWithGoogle();

  Future<Result<void>> signOut();
}
