


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/database/model/chat_block_model.dart';
import 'package:frechat/system/providers.dart';
import 'package:zyg_sqflite_plugin/zyg_sqflite_plugin.dart';

/// 想進行ChatInfo 資料修改使用這個 StateNotifierProvider
final chatBlockModelNotifierProvider = StateNotifierProvider<ChatBlockModelNotifier, List<ChatBlockModel>>((ref) {
  final ChatBlockModel chatBlockModel = ref.read(chatBlockModelProvider);
  return ChatBlockModelNotifier(chatBlockModel: chatBlockModel);
});

class ChatBlockModelNotifier extends StateNotifier<List<ChatBlockModel>> {
  final ChatBlockModel chatBlockModel;
  ChatBlockModelNotifier({required this.chatBlockModel}) : super([]);

  Future<void> loadDataFromSql({ChatBlockModel? whereModel}) async {
    try {
      final List<Map<String, dynamic>> sqlData = await chatBlockModel.selectMatching(model: whereModel);
      final List<ChatBlockModel> list = ChatBlockModel.decode(sqlData);
      state = list;
    } catch (e) {
      print('load Data From Sql error: $e');
      throw Exception('load Data From Sql error: $e');
    }
  }

  Future<void> setDataToSql({
    required List<ChatBlockModel> chatBlockModelList,
    SetDatabaseType setType = SetDatabaseType.insert
  }) async {
    try {
      await chatBlockModel.insert(models: chatBlockModelList, setType: setType);
      loadDataFromSql();

    } catch (e) {
      print('set Data To Sql error: $e');
      throw Exception('set Data To Sql error: $e');
    }
  }

  Future<void> updateDataToSql({
    required ChatBlockModel updateModel,
    required ChatBlockModel whereModel,
  }) async {
    try {
      await chatBlockModel.update(
        updateModel: updateModel,
        whereModel: whereModel
      );
      loadDataFromSql();
    } catch (e) {
      print('update Data To Sql error: $e');
      throw Exception('update Data To Sql error: $e');
    }
  }

  Future<void> clearSql({ChatBlockModel? whereModel}) async {
    try {
      await chatBlockModel.delete(whereModel: whereModel);
      loadDataFromSql();
      state = [];
    } catch (e) {
      print('clear ChatInfo error: $e');
      throw Exception('clear ChatInfo error: $e');
    }
  }
}