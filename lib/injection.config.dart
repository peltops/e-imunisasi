// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i4;
import 'package:firebase_auth/firebase_auth.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i7;

import 'di/app_module.dart' as _i15;
import 'features/authentication/data/repositories/auth_repository.dart' as _i9;
import 'features/authentication/logic/bloc/authentication_bloc/authentication_bloc.dart'
    as _i10;
import 'features/authentication/logic/cubit/local_auth_cubit/local_auth_cubit.dart'
    as _i6;
import 'features/authentication/logic/cubit/login_cubit/login_cubit.dart'
    as _i11;
import 'features/authentication/logic/cubit/login_phone_cubit/login_phone_cubit.dart'
    as _i12;
import 'features/authentication/logic/cubit/reset_password_cubit/reset_password_cubit.dart'
    as _i13;
import 'features/authentication/logic/cubit/signup_cubit/signup_cubit.dart'
    as _i14;
import 'features/splash/data/repositories/splash_repository.dart' as _i8;
import 'services/firebase_services.dart' as _i5;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.factory<_i3.FirebaseAuth>(() => appModule.firebaseAuth);
    gh.factory<_i4.FirebaseFirestore>(() => appModule.firestore);
    await gh.factoryAsync<_i5.FirebaseService>(
      () => appModule.fireService,
      preResolve: true,
    );
    gh.factory<_i6.LocalAuthCubit>(() => _i6.LocalAuthCubit());
    await gh.factoryAsync<_i7.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i8.SplashRepository>(() =>
        _i8.SplashRepository(sharedPreferences: gh<_i7.SharedPreferences>()));
    gh.factory<_i9.AuthRepository>(() => _i9.AuthRepository(
          gh<_i3.FirebaseAuth>(),
          gh<_i4.FirebaseFirestore>(),
        ));
    gh.singleton<_i10.AuthenticationBloc>(_i10.AuthenticationBloc(
      authRepository: gh<_i9.AuthRepository>(),
      splashRepository: gh<_i8.SplashRepository>(),
    ));
    gh.factory<_i11.LoginCubit>(
        () => _i11.LoginCubit(gh<_i9.AuthRepository>()));
    gh.factory<_i12.LoginPhoneCubit>(
        () => _i12.LoginPhoneCubit(gh<_i9.AuthRepository>()));
    gh.factory<_i13.ResetPasswordCubit>(
        () => _i13.ResetPasswordCubit(gh<_i9.AuthRepository>()));
    gh.factory<_i14.SignUpCubit>(
        () => _i14.SignUpCubit(gh<_i9.AuthRepository>()));
    return this;
  }
}

class _$AppModule extends _i15.AppModule {}
