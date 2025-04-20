// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logger/logger.dart' as _i7;
import 'package:shared_preferences/shared_preferences.dart' as _i3;
import 'package:slim_starter_application/core/navigation/navigation_service.dart'
    as _i4;
import 'package:slim_starter_application/core/navigation/route_generator.dart'
    as _i5;
import 'package:slim_starter_application/core/net/http_client.dart' as _i6;
import 'package:slim_starter_application/di/modules/logger_module.dart' as _i10;
import 'package:slim_starter_application/di/modules/shared_preferences_module.dart'
    as _i9;
import 'package:slim_starter_application/services/api.dart' as _i8;

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
    final sharedPreferencesModule = _$SharedPreferencesModule();
    final facebookLoginModule = _$FacebookLoginModule();
    await gh.factoryAsync<_i3.SharedPreferences>(
      () => sharedPreferencesModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i4.NavigationService>(() => _i4.NavigationService());
    gh.lazySingleton<_i5.NavigationRoute>(() => _i5.NavigationRoute());
    gh.lazySingleton<_i6.HttpClient>(() => _i6.HttpClient());
    gh.lazySingleton<_i7.Logger>(() => facebookLoginModule.facebookLogin);
    gh.lazySingleton<_i8.Api>(() => _i8.Api());
    return this;
  }
}

class _$SharedPreferencesModule extends _i9.SharedPreferencesModule {}

class _$FacebookLoginModule extends _i10.FacebookLoginModule {}
