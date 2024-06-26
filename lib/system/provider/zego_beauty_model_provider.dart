
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/database/model/zego_beauty_model.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/zego_call/interal/effects/beauty_ability/zego_beauty_item.dart';
import 'package:frechat/system/zego_call/interal/effects/beauty_ability/zego_beauty_type.dart';
import 'package:frechat/system/zego_call/interal/effects/zego_beauty_data.dart';

/// 想進行ChatInfo 資料修改使用這個 StateNotifierProvider
final zegoBeautyModelNotifierProvider = StateNotifierProvider<ZegoBeautyModelNotifier, List<ZegoBeautyModel>>((ref) {
  final ZegoBeautyModel zegoBeautyModel = ref.read(zegoBeautyModelProvider);
  return ZegoBeautyModelNotifier(zegoBeautyModel: zegoBeautyModel);
});

class ZegoBeautyModelNotifier extends StateNotifier<List<ZegoBeautyModel>> {
  final ZegoBeautyModel zegoBeautyModel;
  ZegoBeautyModelNotifier({required this.zegoBeautyModel}) : super([]);

  Future<void> loadDataFromSql({ZegoBeautyModel? whereModel}) async {
    try {
      final List<Map<String, dynamic>> sqlData = await zegoBeautyModel.selectMatching(model: whereModel);
      final List<ZegoBeautyModel> list = ZegoBeautyModel.decode(sqlData);
      state = list;
    } catch (e) {
      print('load Data From Sql error: $e');
      throw Exception('load Data From Sql error: $e');
    }
  }

  Future<List<ZegoBeautyModel>> loadDataFromModel({ZegoBeautyModel? whereModel}) async {
    try {
      final List<Map<String, dynamic>> sqlData = await zegoBeautyModel.selectMatching(model: whereModel);
      final List<ZegoBeautyModel> list = ZegoBeautyModel.decode(sqlData);
      return list;
    } catch (e) {
      print('load Data From UserName error: $e');
      throw Exception('load Data From UserName error: $e');
    }
  }

  Future<void> setDataToSql({required List<ZegoBeautyModel> zegoBeautyModelList}) async {
    try {
      await zegoBeautyModel.insertOrReplaceBatch(models: zegoBeautyModelList);
      loadDataFromSql();
    } catch (e) {
      print('set Data To Sql error: $e');
      throw Exception('set Data To Sql error: $e');
    }
  }

  Future<void> updateDataToSql({
    required ZegoBeautyModel updateModel,
    required ZegoBeautyModel whereModel,
  }) async {
    try {
      await zegoBeautyModel.update(
        updateModel: updateModel,
        whereModel: whereModel
      );
      loadDataFromSql();
    } catch (e) {
      print('update Data To Sql error: $e');
      throw Exception('update Data To Sql error: $e');
    }
  }

  Future<void> clearSql({ZegoBeautyModel? whereModel}) async {
    try {
      await zegoBeautyModel.delete(whereModel: whereModel);
      loadDataFromSql();
      state = [];
    } catch (e) {
      print('clear ChatInfo error: $e');
      throw Exception('clear ChatInfo error: $e');
    }
  }

  Future<void> reset({ZegoEffectModelType? whereEffectModelType}) async {
    if(whereEffectModelType == null) {
      try {
        List<ZegoBeautyModel> beautyList = [];
        ZegoBeautyType.values.forEach((type) {
          final ZegoBeautyModel model = ZegoBeautyModel(beautyTypeIndex: type.index, currentValue: 50);
          beautyList.add(model);
        });

        await zegoBeautyModel.insertOrReplaceBatch(models: beautyList);
        loadDataFromSql();
      } catch (e) {
        print('set Data To Sql error: $e');
        throw Exception('set Data To Sql error: $e');
      }
      return ;
    }

    try{
      final ZegoEffectModel model = ZegoBeautyData.data.firstWhere((model) => model.type == whereEffectModelType);
      List<ZegoBeautyModel> beautyList = [];
      model.items.forEach((item) {
        final ZegoBeautyType beautyType = ZegoBeautyType.values.firstWhere((type) => type == item.type);
        final ZegoBeautyModel model = ZegoBeautyModel(beautyTypeIndex: beautyType.index, currentValue: 50);
        beautyList.add(model);
      });
      await zegoBeautyModel.insertOrReplaceBatch(models: beautyList);
      loadDataFromSql();
    } catch (e) {
      print('set Data To Sql error: $e');
      throw Exception('set Data To Sql error: $e');
    }
  }
}