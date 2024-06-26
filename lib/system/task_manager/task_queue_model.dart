

class TaskQueueModel {
  TaskQueueModel({required this.userName, required this.taskFunction});

  final String userName;
  final Future<void> Function() taskFunction;
}