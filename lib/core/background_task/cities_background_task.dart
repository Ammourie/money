import 'package:background_fetch/background_fetch.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../common/local_storage.dart';
import '../net/api_url.dart';
import '../net/interceptor.dart';
import 'background_task.dart';

class CitiesBackgroundTask extends BackgroundTask {
  @override
  void execute(bool isKilled) async {
    BaseOptions _options = BaseOptions(
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
      sendTimeout: const Duration(minutes: 1),
      responseType: ResponseType.json,
      baseUrl: APIUrls.BASE_URL,
    );

    final _client = Dio(_options);
    if (isKilled) {
      await LocalStorage.init();
    }
    _client.interceptors.add(AuthInterceptor());

    try {
      final response = await _client.get(APIUrls.API_CITY_LIST);
      debugPrint("data received: ${response.data}");
    } catch (e) {
      debugPrint("Dio error: $e");
    }
  }

  @override
  TaskConfig get config => TaskConfig(
        taskId: "com.transistorsoft.citiesPeriodicTask",
        delay: 30000,
        periodic: true,
        forceAlarmManager: true,
        enableHeadless: true,
        stopOnTerminate: false,
        startOnBoot: true,
      );
}
