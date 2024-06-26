import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frechat/models/req/account_modify_user_req.dart';
import 'package:frechat/models/res/account_modify_user_res.dart';
import 'package:frechat/system/comm/comm.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FcPrefs.mockInitial();
  String resultCodeCheck = '';
  String errorMsgCheck = '';

  test('memberModifyUser', () async {
    final container = ProviderContainer();
    /// ---參考以下---
    // print('memberModifyUser commToken:${commToken}');
    MemberModifyUserReq req = MemberModifyUserReq.create(
      tId: "emptyToken",
      hometown: 'China',
      occupation: 'student',
      annualIncome: '26800',
      education: 'high school',
      age: 18,
      maritalStatus: 0, // 婚姻狀況 0:單身 1:已婚
      weight: 100,
      height: 180,
      // selfIntroduction: 'hi selfIntroduction',
      // avatarImg: File('imgPath'),
      // realPersonImg: File('imgPath'),
      // albumImgs: File('imgPath'),
      // greetingImg: File('imgPath'),
      // greetingAac: File('imgPath'),
      // greetingTxt: File('imgPath'),
      // nickName: 'nickName',
    );
    final memberModifyUserProvider = FutureProvider<MemberModifyUserRes?>((ref) async {
      final res = await ref.read(commApiProvider).memberModifyUser(
          req,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg
      );
      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(memberModifyUserProvider.future);

    if (result != null) {
      print('[MemberModifyUser]: ${jsonEncode(result.toJson())}');
      expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);
    } else {
      print('Oops! memberLogoutRes is null?!');
    }
  });
}