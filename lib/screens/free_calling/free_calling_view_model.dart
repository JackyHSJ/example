import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/call_back_function.dart';

class FreeCallingViewModel {
  WidgetRef ref;
  ViewChange setState;
  BuildContext context;

  FreeCallingViewModel({
    required this.ref,
    required this.setState,
    required this.context,
  });

  num generalCallTime = 0;
  num specificCallTime = 0;
  num vipCallTime = 0;

  List<Map<String, String>> callList = [
    {
      "title": "不限对象通话额度",
      "subTitle": "剩馀免费通话 0 分钟",
      "des": "可对速配视频、速配语音配对到与达成亲密度标准对象免费通话"
    },
    {
      "title": "特定对象通话额度",
      "subTitle": "剩馀免费通话 0 分钟",
      "des": "可对已达亲密度标准对象免费通话"
    },
    {
      "title": "不限对象通话额度",
      "subTitle": "剩馀免费通话 0 分钟",
      "des": "每日不限对象免费通话福利"
    }
  ];


  void init(){
    // getData
    callList[0]['subTitle'] = '剩馀免费通话 $generalCallTime 分钟';
    callList[1]['subTitle'] = '剩馀免费通话 $specificCallTime 分钟';
    callList[2]['subTitle'] = '剩馀免费通话 $vipCallTime 分钟';
    setState((){});
  }

  void dispose(){

  }

  // API
  getData() {

  }

  // API
  setData() {

  }
}