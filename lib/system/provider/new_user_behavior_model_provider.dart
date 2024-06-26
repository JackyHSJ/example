
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/database/model/new_user_behavior_tracker_model.dart';
import 'package:frechat/system/database/model/visitor_time_model.dart';
import 'package:frechat/system/providers.dart';

final newUserBehaviorModelNotifierProvider = StateNotifierProvider<NewUserBehaviorModelNotifier, List<NewUserBehaviorTrackerModel>>((ref) {
  final NewUserBehaviorTrackerModel newUserBehaviorModel = ref.read(newUserBehaviorModelProvider);
  return NewUserBehaviorModelNotifier(newUserBehaviorModel: newUserBehaviorModel);
});

class NewUserBehaviorModelNotifier extends StateNotifier<List<NewUserBehaviorTrackerModel>> {
  final NewUserBehaviorTrackerModel newUserBehaviorModel;
  NewUserBehaviorModelNotifier({required this.newUserBehaviorModel}) : super([]);

  Future<void> loadDataFromSql({NewUserBehaviorTrackerModel? whereModel}) async {
    try {
      final List<Map<String, dynamic>> sqlData = await newUserBehaviorModel.selectMatching(model: whereModel);
      final List<NewUserBehaviorTrackerModel> list = NewUserBehaviorTrackerModel.decode(sqlData);
      state = list;
    } catch (e) {
      print('load Data From Sql error: $e');
      throw Exception('load Data From Sql error: $e');
    }
  }

  Future<List<NewUserBehaviorTrackerModel>> loadDataFromUserName({NewUserBehaviorTrackerModel? whereModel}) async {
    try {
      final List<Map<String, dynamic>> sqlData = await newUserBehaviorModel.selectMatching(model: whereModel);
      final List<NewUserBehaviorTrackerModel> list = NewUserBehaviorTrackerModel.decode(sqlData);
      return list;
    } catch (e) {
      print('load Data From UserName error: $e');
      throw Exception('load Data From UserName error: $e');
    }
  }

  Future<void> setDataToSql({required List<NewUserBehaviorTrackerModel> newUserBehaviorModelList}) async {
    try {
      await newUserBehaviorModel.insertOrReplaceBatch(models: newUserBehaviorModelList);
      loadDataFromSql();
    } catch (e) {
      print('set Data To Sql error: $e');
      throw Exception('set Data To Sql error: $e');
    }
  }

  Future<void> updateDataToSql({
    required NewUserBehaviorTrackerModel updateModel,
    required NewUserBehaviorTrackerModel whereModel,
  }) async {
    try {
      await newUserBehaviorModel.update(
          updateModel: updateModel,
          whereModel: whereModel
      );
      loadDataFromSql();
    } catch (e) {
      print('update Data To Sql error: $e');
      throw Exception('update Data To Sql error: $e');
    }
  }

  Future<void> clearSql({NewUserBehaviorTrackerModel? whereModel}) async {
    try {
      await newUserBehaviorModel.delete(whereModel: whereModel);
      loadDataFromSql();
      state = [];
    } catch (e) {
      print('clear ChatInfo error: $e');
      throw Exception('clear ChatInfo error: $e');
    }
  }
}