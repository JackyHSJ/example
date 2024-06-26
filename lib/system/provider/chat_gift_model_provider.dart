
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/database/model/chat_gift_model.dart';
import 'package:frechat/system/providers.dart';
import 'package:zyg_sqflite_plugin/zyg_sqflite_plugin.dart';

/// 想進行ChatInfo 資料修改使用這個 StateNotifierProvider
final chatGiftModelNotifierProvider = StateNotifierProvider<ChatGiftModelNotifier, List<ChatGiftModel>>((ref) {
  final ChatGiftModel chatGiftModel = ref.read(chatGiftModelProvider);
  return ChatGiftModelNotifier(chatGiftModel: chatGiftModel);
});

class ChatGiftModelNotifier extends StateNotifier<List<ChatGiftModel>> {
  final ChatGiftModel chatGiftModel;
  ChatGiftModelNotifier({required this.chatGiftModel}) : super([]);

  Future<void> loadDataFromSql({ChatGiftModel? whereModel}) async {
    try {
      final List<Map<String, dynamic>> sqlData = await chatGiftModel.selectMatching(model: whereModel);
      final List<ChatGiftModel> list = ChatGiftModel.decode(sqlData);
      state = list;
    } catch (e) {
      print('load Data From Sql error: $e');
      throw Exception('load Data From Sql error: $e');
    }
  }

  Future<void> setDataToSql({
    required List<ChatGiftModel> chatGiftModelList,
    SetDatabaseType setType = SetDatabaseType.insert
  }) async {
    try {
      await chatGiftModel.insert(models: chatGiftModelList, setType: setType);
      loadDataFromSql();
    } catch (e) {
      print('set Data To Sql error: $e');
      throw Exception('set Data To Sql error: $e');
    }
  }

  Future<void> updateDataToSql({
    required ChatGiftModel updateModel,
    required ChatGiftModel whereModel,
  }) async {
    try {
      await chatGiftModel.update(
        updateModel: updateModel,
        whereModel: whereModel
      );
      loadDataFromSql();
    } catch (e) {
      print('update Data To Sql error: $e');
      throw Exception('update Data To Sql error: $e');
    }
  }

  Future<void> clearSql({ChatGiftModel? whereModel}) async {
    try {
      await chatGiftModel.delete(whereModel: whereModel);
      loadDataFromSql();
      state = [];
    } catch (e) {
      print('clear ChatInfo error: $e');
      throw Exception('clear ChatInfo error: $e');
    }
  }
}