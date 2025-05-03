// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:slim_starter_application/core/navigation/navigation_service.dart'
    as _i756;
import 'package:slim_starter_application/core/navigation/route_generator.dart'
    as _i1052;
import 'package:slim_starter_application/core/net/http_client.dart' as _i4;
import 'package:slim_starter_application/di/modules/logger_module.dart'
    as _i698;
import 'package:slim_starter_application/di/modules/shared_preferences_module.dart'
    as _i255;
import 'package:slim_starter_application/services/api.dart' as _i348;
import 'package:slim_starter_application/services/firebase_service.dart'
    as _i928;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final sharedPreferencesModule = _$SharedPreferencesModule();
    final facebookLoginModule = _$FacebookLoginModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => sharedPreferencesModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i756.NavigationService>(() => _i756.NavigationService());
    gh.lazySingleton<_i1052.NavigationRoute>(() => _i1052.NavigationRoute());
    gh.lazySingleton<_i4.HttpClient>(() => _i4.HttpClient());
    gh.lazySingleton<_i974.Logger>(() => facebookLoginModule.facebookLogin);
    gh.lazySingleton<_i348.Api>(() => _i348.Api());
    gh.lazySingleton<_i928.IFirebaseService>(() => _i928.FirebaseService());
    return this;
  }
}

class _$SharedPreferencesModule extends _i255.SharedPreferencesModule {}

class _$FacebookLoginModule extends _i698.FacebookLoginModule {}
