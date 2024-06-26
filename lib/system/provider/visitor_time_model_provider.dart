
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/database/model/visitor_time_model.dart';
import 'package:frechat/system/providers.dart';

/// 想進行ChatInfo 資料修改使用這個 StateNotifierProvider
final visitorTimeModelNotifierProvider = StateNotifierProvider<VisitorTimeModelNotifier, List<VisitorTimeModel>>((ref) {
  final VisitorTimeModel visitorTimeModel = ref.read(visitorTimeModelProvider);
  return VisitorTimeModelNotifier(visitorTimeModel: visitorTimeModel);
});

class VisitorTimeModelNotifier extends StateNotifier<List<VisitorTimeModel>> {
  final VisitorTimeModel visitorTimeModel;
  VisitorTimeModelNotifier({required this.visitorTimeModel}) : super([]);

  Future<void> loadDataFromSql({VisitorTimeModel? whereModel}) async {
    try {
      final List<Map<String, dynamic>> sqlData = await visitorTimeModel.selectMatching(model: whereModel);
      final List<VisitorTimeModel> list = VisitorTimeModel.decode(sqlData);
      state = list;
    } catch (e) {
      print('load Data From Sql error: $e');
      throw Exception('load Data From Sql error: $e');
    }
  }

  Future<List<VisitorTimeModel>> loadDataFromUserName({VisitorTimeModel? whereModel}) async {
    try {
      final List<Map<String, dynamic>> sqlData = await visitorTimeModel.selectMatching(model: whereModel);
      final List<VisitorTimeModel> list = VisitorTimeModel.decode(sqlData);
      return list;
    } catch (e) {
      print('load Data From UserName error: $e');
      throw Exception('load Data From UserName error: $e');
    }
  }

  Future<void> setDataToSql({required List<VisitorTimeModel> visitorTimeModelList}) async {
    try {
      await visitorTimeModel.insertOrReplaceBatch(models: visitorTimeModelList);
      loadDataFromSql();
    } catch (e) {
      print('set Data To Sql error: $e');
      throw Exception('set Data To Sql error: $e');
    }
  }

  Future<void> updateDataToSql({
    required VisitorTimeModel updateModel,
    required VisitorTimeModel whereModel,
  }) async {
    try {
      await visitorTimeModel.update(
        updateModel: updateModel,
        whereModel: whereModel
      );
      loadDataFromSql();
    } catch (e) {
      print('update Data To Sql error: $e');
      throw Exception('update Data To Sql error: $e');
    }
  }

  Future<void> clearSql({VisitorTimeModel? whereModel}) async {
    try {
      await visitorTimeModel.delete(whereModel: whereModel);
      loadDataFromSql();
      state = [];
    } catch (e) {
      print('clear ChatInfo error: $e');
      throw Exception('clear ChatInfo error: $e');
    }
  }
}