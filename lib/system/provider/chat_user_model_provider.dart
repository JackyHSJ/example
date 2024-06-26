
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:frechat/system/providers.dart';
import 'package:zyg_sqflite_plugin/zyg_sqflite_plugin.dart';

/// 想進行ChatInfo 資料修改使用這個 StateNotifierProvider
final chatUserModelNotifierProvider = StateNotifierProvider<ChatUserModelNotifier, List<ChatUserModel>>((ref) {
  final ChatUserModel chatUserModel = ref.read(chatUserModelProvider);
  return ChatUserModelNotifier(chatUserModel: chatUserModel);
});

class ChatUserModelNotifier extends StateNotifier<List<ChatUserModel>> {
  final ChatUserModel chatUserModel;
  ChatUserModelNotifier({required this.chatUserModel}) : super([]);

  Future<void> loadDataFromSql({ChatUserModel? whereModel}) async {
    try {
      final List<Map<String, dynamic>> sqlData = await chatUserModel.selectMatching(model: whereModel);
      final List<ChatUserModel> list = ChatUserModel.decode(sqlData);
      state = list;
    } catch (e) {
      print('load Data From Sql error: $e');
      throw Exception('load Data From Sql error: $e');
    }
  }

  Future<List<ChatUserModel>> loadDataFromUserName({ChatUserModel? whereModel}) async {
    try {
      final List<Map<String, dynamic>> sqlData = await chatUserModel.selectMatching(model: whereModel);
      final List<ChatUserModel> list = ChatUserModel.decode(sqlData);
      return list;
    } catch (e) {
      print('load Data From UserName error: $e');
      throw Exception('load Data From UserName error: $e');
    }
  }

  Future<void> setDataToSql({
    required List<ChatUserModel> chatUserModelList,
    SetDatabaseType setType = SetDatabaseType.insert
  }) async {
    try {
      await chatUserModel.insert(models: chatUserModelList, setType: setType);
      await loadDataFromSql();
    } catch (e) {
      print('set Data To Sql error: $e');
      throw Exception('set Data To Sql error: $e');
    }
  }

  Future<void> updateDataToSql({
    required ChatUserModel updateModel,
    required ChatUserModel whereModel,
  }) async {
    try {
      await chatUserModel.update(
        updateModel: updateModel,
        whereModel: whereModel
      );
      await loadDataFromSql();
    } catch (e) {
      print('update Data To Sql error: $e');
      throw Exception('update Data To Sql error: $e');
    }
  }

  Future<void> clearSql({ChatUserModel? whereModel}) async {
    try {
      await chatUserModel.delete(whereModel: whereModel);
      loadDataFromSql();
      state = [];
    } catch (e) {
      print('clear ChatInfo error: $e');
      throw Exception('clear ChatInfo error: $e');
    }
  }
}