

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/database/model/chat_call_model.dart';
import 'package:frechat/system/providers.dart';
import 'package:zyg_sqflite_plugin/zyg_sqflite_plugin.dart';

/// 想進行ChatInfo 資料修改使用這個 StateNotifierProvider
final chatCallModelNotifierProvider = StateNotifierProvider<ChatCallModelNotifier, List<ChatCallModel>>((ref) {
  final ChatCallModel chatCallModel = ref.read(chatCallModelProvider);
  return ChatCallModelNotifier(chatCallModel: chatCallModel);
});

class ChatCallModelNotifier extends StateNotifier<List<ChatCallModel>> {
  final ChatCallModel chatCallModel;
  ChatCallModelNotifier({required this.chatCallModel}) : super([]);

  Future<void> loadDataFromSql({ChatCallModel? whereModel}) async {
    try {
      final List<Map<String, dynamic>> sqlData = await chatCallModel.selectMatching(model: whereModel);
      final List<ChatCallModel> list = ChatCallModel.decode(sqlData);
      state = list;
    } catch (e) {
      print('load Data From Sql error: $e');
      throw Exception('load Data From Sql error: $e');
    }
  }

  Future<void> setDataToSql({
    required List<ChatCallModel> chatCallModelList,
    SetDatabaseType setType = SetDatabaseType.insert
  }) async {
    try {
      await chatCallModel.insert(models: chatCallModelList, setType: setType);
      loadDataFromSql();
    } catch (e) {
      print('set Data To Sql error: $e');
      throw Exception('set Data To Sql error: $e');
    }
  }

  Future<void> updateDataToSql({
    required ChatCallModel updateModel,
    required ChatCallModel whereModel,
  }) async {
    try {
      await chatCallModel.update(
        updateModel: updateModel,
        whereModel: whereModel
      );
      loadDataFromSql();
    } catch (e) {
      print('update Data To Sql error: $e');
      throw Exception('update Data To Sql error: $e');
    }
  }

  Future<void> clearSql({ChatCallModel? whereModel}) async {
    try {
      await chatCallModel.delete(whereModel: whereModel);
      loadDataFromSql();
      state = [];
    } catch (e) {
      print('clear ChatInfo error: $e');
      throw Exception('clear ChatInfo error: $e');
    }
  }
}