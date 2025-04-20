import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/foundation.dart';

import 'background_task.dart';

// [Android-only] This "Headless Task" is run when the Android app is terminated with `enableHeadless: true`
// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;

  if (isTimeout) {
    BackgroundFetch.finish(taskId);
    return;
  }

  final index = BackgroundTasksManager.tasks
      .indexWhere((task) => taskId == task.config.taskId);
  if (index != -1) {
    BackgroundTasksManager.tasks[index].execute(true);
  }

  BackgroundFetch.finish(taskId);
}

class BackgroundTasksManager {
  BackgroundTasksManager._();

  static List<BackgroundTask> get tasks => _tasks;
  static final List<BackgroundTask> _tasks = [
    // CitiesBackgroundTask(),
  ];

  static Future<void> init() async {
    if (_tasks.isNotEmpty) {
      try {
        // Register to receive BackgroundFetch events after app is terminated.
        // Requires {stopOnTerminate: false, enableHeadless: true}
        await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

        await BackgroundFetch.configure(
          BackgroundFetchConfig(
            minimumFetchInterval: 15,
            startOnBoot: true,
            stopOnTerminate: false,
            enableHeadless: true,
            requiredNetworkType: NetworkType.NONE,
            forceAlarmManager: false,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresDeviceIdle: false,
            requiresStorageNotLow: false,
          ),
          (taskId) {
            final index =
                _tasks.indexWhere((task) => taskId == task.config.taskId);
            if (index != -1) {
              _tasks[index].execute(false);
            }
          },
          (taskId) {
            BackgroundFetch.finish(taskId);
          },
        );

        debugPrint("Starting background tasks");
        await _start();
      } catch (e) {
        debugPrint("[BackgroundFetch] configure ERROR: $e");
      }
    }
  }

  static Future<void> _start() async {
    for (final task in _tasks) {
      BackgroundFetch.scheduleTask(task.config).then((value) {
        debugPrint(
          "Task id: ${task.config.taskId} ${value ? "Scheduled" : "Failed scheduled"}",
        );
      });
    }
  }
}
