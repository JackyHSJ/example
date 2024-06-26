import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frechat/models/req/member_login_req.dart';
import 'package:frechat/models/req/member_logout_req.dart';
import 'package:frechat/models/req/member_register_req.dart';
import 'package:frechat/models/res/base_res.dart';
import 'package:frechat/models/res/member_login_res.dart';
import 'package:frechat/models/res/member_logout_res.dart';
import 'package:frechat/models/res/member_register_res.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/comm/comm.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String resultCodeCheck = '';
  String errorMsgCheck = '';

  test('keepAliveCheck', () async {
    final container = ProviderContainer();
    final keepAliveCheckProvider = FutureProvider<BaseRes?>((ref) async {
      /// ---參考以下---
      final res = await ref.read(commApiProvider).keepAliveCheck(
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg
      );
      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(keepAliveCheckProvider.future);

    if (result != null) {
      print('[keepAliveCheck]: ${jsonEncode(result.toJson())}');
      expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);
    } else {
      print('Oops! baseRes is null?!');
    }

    // 清理 container
    container.dispose();
  });

  test('memberRegister', () async {
    final container = ProviderContainer();
    try {
      /// ---參考以下---
      MemberRegisterReq req = MemberRegisterReq.create(
          env: 'DEV',  //環境
          phoneNumber: '18601689858', //手機號
          phoneToken: '', //一鍵登入Token
          nickName: 'SuperMan', //暱稱
          firstRegPackage: 'HelloWorld',  //首次注册包
          code: '',   //邀请码
          gender: '0', //性别 (0/1)
          age: '18',  //年龄
          deviceModel: 'pixel',   //设备型号
          currentVersion: '0.0.1',  //当前版本号
          systemVersion: '10', avatarImg: File(''),
          merchant: 'HUAWEI'
      );   //系统版本

      final memberRegisterProvider = FutureProvider<MemberRegisterRes?>((ref) async {
        final res = await ref.read(commApiProvider).memberRegister(
          req,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg
        );
        /// ---參考以上---
        return res;
      });

      // 使用 container.read 讀取 provider
      final result = await container.read(memberRegisterProvider.future);

      if (result != null) {
        print('[memberRegister]: ${jsonEncode(result.toJson())}');
        expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);
      } else {
        print('Oops! memberRegisterRes is null?!');
      }
    } catch (err) {
      print('Error: $err');
    }

    // 清理 container
    container.dispose();
  });

  test('memberLogin', () async {
    final container = ProviderContainer();
    MemberLoginReq req = MemberLoginReq.create(
        env: 'DEV',  //環境
        phoneNumber: '18601689858', //手機號
        phoneToken: '', //一鍵登入Token
        deviceModel: 'pixel',   //设备型号
        currentVersion: '0.0.1',  //当前版本号
        systemVersion: '10',
        tdata: '',
        tokenType: '',
        merchant: 'HUAWEI',
        version: AppConfig.appVersion
    );   //系统版本

    final memberLoginProvider = FutureProvider<MemberLoginRes?>((ref) async {
      final res = await ref.read(commApiProvider).memberLogin(
          req,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg
      );
      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(memberLoginProvider.future);

    if (result != null) {
      print('[memberLogin]: ${jsonEncode(result.toJson())}');
      expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);
    } else {
      print('Oops! memberLoginRes is null?!');
    }
  });

  test('memberLogout', () async {
    final container = ProviderContainer();
    MemberLogoutReq req = MemberLogoutReq.create(tId: '');
    print(req.tId);

    final memberLogoutProvider = FutureProvider<MemberLogoutRes?>((ref) async {
      final res = await ref.read(commApiProvider).memberLogout(
          req,
          onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
          onConnectFail: (errMsg) => errorMsgCheck = errMsg
      );
      /// ---參考以上---
      return res;
    });

    // 使用 container.read 讀取 provider
    final result = await container.read(memberLogoutProvider.future);

    if (result != null) {
      print('[MemberLogout]: ${jsonEncode(result.toJson())}');
      expect(resultCodeCheck, ResponseCode.CODE_SUCCESS);
    } else {
      print('Oops! memberLogoutRes is null?!');
    }

    // 清理 container
    container.dispose();
  });
}
