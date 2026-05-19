import 'package:flutter_test/flutter_test.dart';
import 'package:tikwiki/core/error/result.dart';
import 'package:tikwiki/features/auth/domain/entities/user_entity.dart';
import 'package:tikwiki/features/auth/domain/repositories/auth_repository.dart';
import 'package:tikwiki/features/auth/domain/use_cases/sign_in_with_google_use_case.dart';

void main() {
  group('SignInWithGoogleUseCase', () {
    test('triggers sign in with google on repository', () async {
      final repository = _FakeAuthRepository();
      final useCase = SignInWithGoogleUseCase(repository);

      final result = await useCase();

      expect(result, isA<Success<UserEntity>>());
      expect(repository.signInWithGoogleCalled, true);
    });
  });
}

class _FakeAuthRepository implements AuthRepository {
  @override
  UserEntity? get currentUser => null;

  @override
  Stream<UserEntity?> get authStateChanges => const Stream<UserEntity?>.empty();

  bool signInWithGoogleCalled = false;

  @override
  Future<Result<UserEntity?>> getCurrentUser() async => const Success(null);

  @override
  Future<Result<UserEntity>> signInWithGoogle() async {
    signInWithGoogleCalled = true;
    return const Success(
      UserEntity(uid: 'u1', email: 'user@gmail.com', displayName: 'Google User'),
    );
  }

  @override
  Future<Result<void>> signOut() async => const Success(null);
}
