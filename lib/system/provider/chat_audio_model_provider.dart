


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/database/model/chat_audio_model.dart';
import 'package:frechat/system/providers.dart';
import 'package:zyg_sqflite_plugin/zyg_sqflite_plugin.dart';

/// 想進行ChatInfo 資料修改使用這個 StateNotifierProvider
final chatAudioModelNotifierProvider = StateNotifierProvider<ChatAudioModelNotifier, List<ChatAudioModel>>((ref) {
  final ChatAudioModel chatAudioModel = ref.read(chatAudioModelProvider);
  return ChatAudioModelNotifier(chatAudioModel: chatAudioModel);
});

class ChatAudioModelNotifier extends StateNotifier<List<ChatAudioModel>> {
  final ChatAudioModel chatAudioModel;
  ChatAudioModelNotifier({required this.chatAudioModel}) : super([]);

  Future<void> loadDataFromSql({ChatAudioModel? whereModel}) async {
    try {
      final List<Map<String, dynamic>> sqlData = await chatAudioModel.selectMatching(model: whereModel);
      final List<ChatAudioModel> list = ChatAudioModel.decode(sqlData);
      state = list;
    } catch (e) {
      print('load Data From Sql error: $e');
      throw Exception('load Data From Sql error: $e');
    }
  }

  Future<void> setDataToSql({
    required List<ChatAudioModel> chatAudioModelList,
    SetDatabaseType setType = SetDatabaseType.insert
  }) async {
    try {
      await chatAudioModel.insert(models: chatAudioModelList, setType: setType);
      loadDataFromSql();
    } catch (e) {
      print('set Data To Sql error: $e');
      throw Exception('set Data To Sql error: $e');
    }
  }

  Future<void> updateDataToSql({
    required ChatAudioModel updateModel,
    required ChatAudioModel whereModel,
  }) async {
    try {
      await chatAudioModel.update(
        updateModel: updateModel,
        whereModel: whereModel
      );
      loadDataFromSql();
    } catch (e) {
      print('update Data To Sql error: $e');
      throw Exception('update Data To Sql error: $e');
    }
  }

  Future<void> clearSql({ChatAudioModel? whereModel}) async {
    try {
      await chatAudioModel.delete(whereModel: whereModel);
      loadDataFromSql();
      state = [];
    } catch (e) {
      print('clear ChatInfo error: $e');
      throw Exception('clear ChatInfo error: $e');
    }
  }
}