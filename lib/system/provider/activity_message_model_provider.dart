
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/database/model/activity_message_model.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/providers.dart';

/// 想進行ChatInfo 資料修改使用這個 StateNotifierProvider
final activityMessageModelNotifierProvider = StateNotifierProvider<ActivityMessageModelNotifier, List<ActivityMessageModel>>((ref) {
  final ActivityMessageModel activityMessageModel = ref.read(activityMessageModelProvider);
  return ActivityMessageModelNotifier(activityMessageModel: activityMessageModel);
});

class ActivityMessageModelNotifier extends StateNotifier<List<ActivityMessageModel>> {
  final ActivityMessageModel activityMessageModel;
  ActivityMessageModelNotifier({required this.activityMessageModel}) : super([]);

  Future<void> loadDataFromSql({ActivityMessageModel? whereModel}) async {
    try {
      final List<Map<String, dynamic>> sqlData = await activityMessageModel.selectMatching(model: whereModel);
      final List<ActivityMessageModel> list = ActivityMessageModel.decode(sqlData);
      state = list;
    } catch (e) {
      print('load Data From Sql error: $e');
      throw Exception('load Data From Sql error: $e');
    }
  }

  Future<List<ActivityMessageModel>> loadDataFromUserName({ActivityMessageModel? whereModel}) async {
    try {
      final List<Map<String, dynamic>> sqlData = await activityMessageModel.selectMatching(model: whereModel);
      final List<ActivityMessageModel> list = ActivityMessageModel.decode(sqlData);
      return list;
    } catch (e) {
      print('load Data From UserName error: $e');
      throw Exception('load Data From UserName error: $e');
    }
  }

  Future<void> setDataToSql({required List<ActivityMessageModel> activityMessageModelList}) async {
    try {
      await activityMessageModel.insertOrReplaceBatch(models: activityMessageModelList);
      loadDataFromSql();
    } catch (e) {
      print('set Data To Sql error: $e');
      throw Exception('set Data To Sql error: $e');
    }
  }

  Future<void> updateDataToSql({
    required ActivityMessageModel updateModel,
    required ActivityMessageModel whereModel,
  }) async {
    try {
      await activityMessageModel.update(
          updateModel: updateModel,
          whereModel: whereModel
      );
      loadDataFromSql();
    } catch (e) {
      print('update Data To Sql error: $e');
      throw Exception('update Data To Sql error: $e');
    }
  }

  Future<void> clearSql({ActivityMessageModel? whereModel}) async {
    try {
      await activityMessageModel.delete(whereModel: whereModel);
      loadDataFromSql();
      state = [];
    } catch (e) {
      print('clear ChatInfo error: $e');
      throw Exception('clear ChatInfo error: $e');
    }
  }
}