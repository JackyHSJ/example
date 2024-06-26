
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/providers.dart';

class PersonalOnlineServiceChatViewModel {
  PersonalOnlineServiceChatViewModel({
    required this.ref
  });
  WidgetRef ref;

  init() {

  }

  dispose() {

  }

  num getUserId() {
    final num userId = ref.read(userInfoProvider).userId ?? 0;
    return userId;
  }

  String getUserName() {
    final String userName = ref.read(userInfoProvider).memberInfo?.userName ?? '';
    return userName;
  }
}