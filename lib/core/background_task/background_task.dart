import 'package:background_fetch/background_fetch.dart';

/// **Note**: When create a background task you must to add it to task list in `background_tasks_manager.dart`
/// ## Examples
/// `1- Schedule one shot task.`
/// ```dart
/// class BackgroundTaskOneShot extends BackgroundTask {
///   @override
///   void execute(bool isKilled) {
///     showToast("Hello i am one shot task");
///   }
///   @override
///   TaskConfig get config => TaskConfig(
///         taskId: "oneShotTask",
///         delay: 10000,
///       );
/// }
/// ```
/// `2- Schedule periodic task.`
/// ```dart
/// class BackgroundTaskPeriodic extends BackgroundTask {
///   @override
///   void execute(bool isKilled) {
///     showToast("Hello i am periodic task");
///   }
///   @override
///   TaskConfig get config => TaskConfig(
///         taskId: "periodicTask",
///         delay: 5000,
///         periodic: true,
///         forceAlarmManager: true,
///       );
/// }
/// ```
///
abstract class BackgroundTask {
  BackgroundTask();

  TaskConfig get config;
  void execute(bool isKilled);
}
