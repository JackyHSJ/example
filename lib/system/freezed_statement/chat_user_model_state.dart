
import 'package:frechat/system/database/model/chat_user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_user_model_state.freezed.dart';

@freezed
class ChatUserModelState with _$ChatUserModelState {
  const factory ChatUserModelState.init() = ChatUserModelInitial;
  const factory ChatUserModelState.loading() = ChatUserModelLoading;
  const factory ChatUserModelState.data({required List<ChatUserModel> chatUserModelList}) = ChatUserModelData;
  const factory ChatUserModelState.error({required String msg}) = ChatUserModelError;
}