import 'package:injectable/injectable.dart';
import 'package:tikwiki/core/error/result.dart';
import 'package:tikwiki/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class SignOutUseCase {
  SignOutUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call() => _repository.signOut();
}
