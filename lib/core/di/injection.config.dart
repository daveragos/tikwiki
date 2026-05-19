// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:tikwiki/core/firebase/firebase_module.dart' as _i115;
import 'package:tikwiki/core/network/dio_http_client.dart' as _i927;
import 'package:tikwiki/core/network/dio_module.dart' as _i580;
import 'package:tikwiki/core/network/http_client.dart' as _i214;
import 'package:tikwiki/features/auth/data/data_sources/auth_local_data_source.dart'
    as _i170;
import 'package:tikwiki/features/auth/data/data_sources/auth_remote_data_source.dart'
    as _i732;
import 'package:tikwiki/features/auth/data/repositories/auth_repository_impl.dart'
    as _i539;
import 'package:tikwiki/features/auth/domain/repositories/auth_repository.dart'
    as _i197;
import 'package:tikwiki/features/auth/domain/use_cases/get_current_user_use_case.dart'
    as _i161;
import 'package:tikwiki/features/auth/domain/use_cases/observe_auth_state_changes_use_case.dart'
    as _i74;
import 'package:tikwiki/features/auth/domain/use_cases/sign_in_with_google_use_case.dart'
    as _i1052;
import 'package:tikwiki/features/auth/domain/use_cases/sign_out_use_case.dart'
    as _i654;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final firebaseModule = _$FirebaseModule();
    final dioModule = _$DioModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.lazySingleton<_i116.GoogleSignIn>(() => firebaseModule.googleSignIn);
    gh.lazySingleton<_i361.Dio>(() => dioModule.dio);
    gh.lazySingleton<_i170.AuthLocalDataSource>(
      () => _i170.AuthLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i732.AuthRemoteDataSource>(
      () => _i732.AuthRemoteDataSourceImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i974.FirebaseFirestore>(),
        gh<_i116.GoogleSignIn>(),
      ),
    );
    gh.lazySingleton<_i214.HttpClient>(
      () => _i927.DioHttpClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i197.AuthRepository>(
      () => _i539.AuthRepositoryImpl(gh<_i732.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i161.GetCurrentUserUseCase>(
      () => _i161.GetCurrentUserUseCase(gh<_i197.AuthRepository>()),
    );
    gh.lazySingleton<_i74.ObserveAuthStateChangesUseCase>(
      () => _i74.ObserveAuthStateChangesUseCase(gh<_i197.AuthRepository>()),
    );
    gh.lazySingleton<_i1052.SignInWithGoogleUseCase>(
      () => _i1052.SignInWithGoogleUseCase(gh<_i197.AuthRepository>()),
    );
    gh.lazySingleton<_i654.SignOutUseCase>(
      () => _i654.SignOutUseCase(gh<_i197.AuthRepository>()),
    );
    return this;
  }
}

class _$FirebaseModule extends _i115.FirebaseModule {}

class _$DioModule extends _i580.DioModule {}
