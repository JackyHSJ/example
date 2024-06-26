import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frechat/models/req/report/report_user_req.dart';
import 'package:frechat/models/res/report_user_res.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FcPrefs.mockInitial();
  String resultCodeCheck = '';
  String errorMsgCheck = '';

  test('reportUser', () async {
    final container = ProviderContainer();
    // final String commToken = await FcPrefs.getCommToken();
    // print('reportUser commToken:${commToken}');
    /// ---參考以下---
    ReportUserReq req = ReportUserReq.create(
      tId: "emptyToken",
      type: 0,
      remark: 'boy is too handsome',
      userId: 42,
      reportSettingId: 1
    );

    final reportUserProvider = FutureProvider<ReportUserRes?>((ref) async {
      final res = await ref.read(commApiProvider).reportUser(
          req,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg
      );
      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(reportUserProvider.future);

    if (result != null) {
      print('[ReportUser]: ${jsonEncode(result.toJson())}');
      expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);
    } else {
      print('Oops! reportUserRes is null?!');
    }
  });
}