import 'package:injectable/injectable.dart';
import 'package:tikwiki/core/error/result.dart';
import 'package:tikwiki/features/auth/domain/entities/user_entity.dart';
import 'package:tikwiki/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class GetCurrentUserUseCase {
  GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<UserEntity?>> call() => _repository.getCurrentUser();
}
