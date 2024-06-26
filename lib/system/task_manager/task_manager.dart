import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/task_manager/task_queue_model.dart';

class TaskManager {
  final Queue<TaskQueueModel> _taskQueue = Queue<TaskQueueModel>();
  bool _isProcessing = false;
  late Function() onTaskQueueAdd;
  late Function() onTaskQueueDone;

  /// hashCode 用來比對同一畫面物件傳送相同資料時可以做比對避免同樣Req重複發送
  void enqueueTask({
    required TaskQueueModel task,
    required Function() onTaskQueueAdd,
    required Function() onTaskQueueDone,
  }) async {
    this.onTaskQueueAdd = onTaskQueueAdd;
    this.onTaskQueueDone = onTaskQueueDone;

    _taskQueue.add(task);
    this.onTaskQueueAdd();
    // await _waitingForQueue();
    if(_isProcessing == false) {
      await processQueue();
    }
  }

  Future<void> processQueue() async {
    if (_isProcessing || _taskQueue.isEmpty) return;
    _isProcessing = true;

    /// timeout
    try {
      await _taskQueue.first.taskFunction.call().timeout(const Duration(seconds: 10));
    } on TimeoutException catch (_) {
      final BuildContext context = BaseViewModel.getGlobalContext();
      if(context.mounted) BaseViewModel.showToast(context, '亲～搭讪失败啰');
    } finally {
      _isProcessing = false;
    }
    
    _taskQueue.removeFirst();
    onTaskQueueDone();
    if (_taskQueue.isNotEmpty) {
      await processQueue();
    }
  }

  Future<void> _waitingForQueue() async {
    await Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 100)); // 檢查頻率，每100毫秒檢查連線狀態
      return _isProcessing == true;
    });
  }
}
