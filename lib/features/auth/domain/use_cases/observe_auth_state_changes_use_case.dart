import 'package:injectable/injectable.dart';
import 'package:tikwiki/features/auth/domain/entities/user_entity.dart';
import 'package:tikwiki/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class ObserveAuthStateChangesUseCase {
  ObserveAuthStateChangesUseCase(this._repository);

  final AuthRepository _repository;

  Stream<UserEntity?> call() => _repository.authStateChanges;
}
