import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/req/member_register_req.dart';
import 'package:frechat/models/res/member_register_res.dart';
import 'package:frechat/system/providers.dart';

/// 提供註冊資料狀態暫存, 用意是讓 Home 可以判斷當前是否使用者剛註冊完成
class MemberRegisterResStateNotifier extends StateNotifier<MemberRegisterRes?> {
  MemberRegisterResStateNotifier() : super(null);
  /// 使用 commAPI 主動刷新當前狀態。
  Future<MemberRegisterRes?> memberRegister(WidgetRef ref, MemberRegisterReq req,
      {required Function(String) onConnectSuccess, required Function(String) onConnectFail}) async {
    MemberRegisterRes? res = await ref
        .read(commApiProvider)
        .memberRegister(req, onConnectSuccess: onConnectSuccess, onConnectFail: onConnectFail);

    state = res;

    return res;
  }

  void clearState() {
    state = null;
  }
}
