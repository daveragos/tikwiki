import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tikwiki/core/di/injection.dart';
import 'package:tikwiki/core/error/result.dart';
import 'package:tikwiki/features/auth/domain/entities/user_entity.dart';
import 'package:tikwiki/features/auth/domain/use_cases/observe_auth_state_changes_use_case.dart';
import 'package:tikwiki/features/auth/domain/use_cases/sign_in_with_google_use_case.dart';
import 'package:tikwiki/features/auth/domain/use_cases/sign_out_use_case.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  late final ObserveAuthStateChangesUseCase _observeAuthStateChanges;
  late final SignInWithGoogleUseCase _signInWithGoogle;
  late final SignOutUseCase _signOut;

  @override
  Stream<UserEntity?> build() {
    _observeAuthStateChanges = container<ObserveAuthStateChangesUseCase>();
    _signInWithGoogle = container<SignInWithGoogleUseCase>();
    _signOut = container<SignOutUseCase>();

    return _observeAuthStateChanges();
  }

  Future<Result<UserEntity>> signInWithGoogle() {
    return _signInWithGoogle();
  }

  Future<Result<void>> signOut() {
    return _signOut();
  }
}
