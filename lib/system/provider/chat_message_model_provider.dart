
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_message_model.dart';
import 'package:frechat/system/providers.dart';
import 'package:zyg_sqflite_plugin/zyg_sqflite_plugin.dart';

/// 想進行ChatInfo 資料修改使用這個 StateNotifierProvider
final chatMessageModelNotifierProvider = StateNotifierProvider<ChatMessageModelNotifier, List<ChatMessageModel>>((ref) {
  final ChatMessageModel chatMessageModel = ref.read(chatMessageModelProvider);
  return ChatMessageModelNotifier(chatMessageModel: chatMessageModel);
});

class ChatMessageModelNotifier extends StateNotifier<List<ChatMessageModel>> {
  final ChatMessageModel chatMessageModel;
  ChatMessageModelNotifier({required this.chatMessageModel}) : super([]);

  Future<void> loadDataFromSql({ChatMessageModel? whereModel}) async {
    try {
      final List<Map<String, dynamic>> sqlData = await chatMessageModel.selectMatching(model: whereModel);
      final List<ChatMessageModel> list = ChatMessageModel.decode(sqlData);
      state = list;
    } catch (e) {
      print('load Data From Sql error: $e');
      throw Exception('load Data From Sql error: $e');
    }
  }

  // Future<List<ChatMessageModel>> loadDataWithoutState({ChatMessageModel? whereModel}) async {
  //   try {
  //     final List<Map<String, dynamic>> sqlData = await chatMessageModel.selectMatching(model: whereModel);
  //     final List<ChatMessageModel> list = ChatMessageModel.decode(sqlData);
  //     return list;
  //   } catch (e) {
  //     print('load Data From Sql error: $e');
  //     throw Exception('load Data From Sql error: $e');
  //   }
  // }

  Future<void> setDataToSql({
    required List<ChatMessageModel> chatMessageModelList,
    SetDatabaseType setType = SetDatabaseType.insert
  }) async {
    try {
      await chatMessageModel.insert(models: chatMessageModelList, setType: setType);
      loadDataFromSql();
    } catch (e) {
      print('set Data To Sql error: $e');
      throw Exception('set Data To Sql error: $e');
    }
  }

  Future<void> updateDataToSql({
    required ChatMessageModel updateModel,
    required ChatMessageModel whereModel,
  }) async {
    try {
      await chatMessageModel.update(
        updateModel: updateModel,
        whereModel: whereModel
      );
      loadDataFromSql();
    } catch (e) {
      print('update Data To Sql error: $e');
      throw Exception('update Data To Sql error: $e');
    }
  }

  Future<void> clearSql({ChatMessageModel? whereModel}) async {
    try {
      await chatMessageModel.delete(whereModel: whereModel);
      loadDataFromSql();
      state = [];
    } catch (e) {
      print('clear ChatInfo error: $e');
      throw Exception('clear ChatInfo error: $e');
    }
  }
}