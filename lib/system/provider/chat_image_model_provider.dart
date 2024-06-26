


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/database/model/chat_image_model.dart';
import 'package:frechat/system/providers.dart';
import 'package:zyg_sqflite_plugin/zyg_sqflite_plugin.dart';

/// 想進行ChatInfo 資料修改使用這個 StateNotifierProvider
final chatImageModelNotifierProvider = StateNotifierProvider<ChatImageModelNotifier, List<ChatImageModel>>((ref) {
  final ChatImageModel chatImageModel = ref.read(chatImageModelProvider);
  return ChatImageModelNotifier(chatImageModel: chatImageModel);
});

class ChatImageModelNotifier extends StateNotifier<List<ChatImageModel>> {
  final ChatImageModel chatImageModel;
  ChatImageModelNotifier({required this.chatImageModel}) : super([]);

  Future<void> loadDataFromSql({ChatImageModel? whereModel}) async {
    try {
      final List<Map<String, dynamic>> sqlData = await chatImageModel.selectMatching(model: whereModel);
      final List<ChatImageModel> list = ChatImageModel.decode(sqlData);
      state = list;
    } catch (e) {
      print('load Data From Sql error: $e');
      throw Exception('load Data From Sql error: $e');
    }
  }

  Future<void> setDataToSql({
    required List<ChatImageModel> chatImageModelList,
    SetDatabaseType setType = SetDatabaseType.insert
  }) async {
    try {
      await chatImageModel.insert(models: chatImageModelList, setType: setType);
      loadDataFromSql();
    } catch (e) {
      print('set Data To Sql error: $e');
      throw Exception('set Data To Sql error: $e');
    }
  }

  Future<void> updateDataToSql({
    required ChatImageModel updateModel,
    required ChatImageModel whereModel,
  }) async {
    try {
      await chatImageModel.update(
        updateModel: updateModel,
        whereModel: whereModel
      );
      loadDataFromSql();
    } catch (e) {
      print('update Data To Sql error: $e');
      throw Exception('update Data To Sql error: $e');
    }
  }

  Future<void> clearSql({ChatImageModel? whereModel}) async {
    try {
      await chatImageModel.delete(whereModel: whereModel);
      loadDataFromSql();
      state = [];
    } catch (e) {
      print('clear ChatInfo error: $e');
      throw Exception('clear ChatInfo error: $e');
    }
  }
}