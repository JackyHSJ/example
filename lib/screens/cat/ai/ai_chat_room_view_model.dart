

import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/cat/ai/ai_constant.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/zego_call/interal/zim/zim_service_defines.dart';
import 'package:uuid/uuid.dart';
import 'package:zyg_open_ai_plugin/zyg_open_ai_plugin.dart';

class AiChatRoomModel {
  AiChatRoomModel({required this.title, required this.onTap});
  String title;
  Function() onTap;
}

class AiChatRoomViewModel {
  AiChatRoomViewModel({required this.setState, required this.ref}) {
    _initOptionList();
  }

  ViewChange setState;
  WidgetRef ref;

  List<ZIMMessage> chatList = [];
  late TextEditingController textController;
  late FocusNode textFocusNode;
  List<String>? fineTuneList;

  String optionTitle = '';
  List<AiChatRoomModel> optionModelList = [];
  List<AiChatRoomModel> test1 = [];
  List<AiChatRoomModel> test2 = [];
  List<AiChatRoomModel> test3 = [];

  init() {
    textController = TextEditingController();
    textFocusNode = FocusNode();
    AiChatManager.init();
    _initFineTune();
  }

  _initOptionList() {
    optionTitle = '我可以帮你什么忙呢？';
    optionModelList = [
      AiChatRoomModel(title: '', onTap: (){}),
      AiChatRoomModel(title: '每日运势', onTap: () => _onTapFate()),
      AiChatRoomModel(title: '小狗冷知识', onTap: () => _onTapTrivia()),
      AiChatRoomModel(title: '小测验', onTap: () => _ontTapTest1()),
    ];

    test1 = [
      AiChatRoomModel(title: '', onTap: (){}),
      AiChatRoomModel(title: '白色：纯洁、简单', onTap: () => _test2()),
      AiChatRoomModel(title: '橘色：热情、活力', onTap: () => _test2()),
      AiChatRoomModel(title: '灰色：冷静、理性', onTap: () => _test2()),
      AiChatRoomModel(title: '斑点/花纹：复杂、有趣', onTap: () => _test2()),
    ];

    test2 = [
      AiChatRoomModel(title: '', onTap: (){}),
      AiChatRoomModel(title: '室内的沙发上：喜欢舒适、安全', onTap: () => _test3()),
      AiChatRoomModel(title: '阳光明媚的花园：喜欢自由、探险', onTap: () => _test3()),
      AiChatRoomModel(title: '高高的树上：独立、追求高度', onTap: () => _test3()),
      AiChatRoomModel(title: '厨房里，靠近食物的地方：喜欢美食、贴近生活', onTap: () => _test3()),
    ];

    test3 = [
      AiChatRoomModel(title: '', onTap: (){}),
      AiChatRoomModel(title: '懒洋洋的睡觉：放松、宁静', onTap: () {_testResult(); _initOptionList();}),
      AiChatRoomModel(title: '好奇地观察周围：对生活充满好奇心', onTap: () {_testResult(); _initOptionList();}),
      AiChatRoomModel(title: '优雅自信的姿态：自信、优雅', onTap: () {_testResult(); _initOptionList();}),
      AiChatRoomModel(title: '看起来有点淘气的表情：喜爱调皮、有趣', onTap: () {_testResult(); _initOptionList();}),
    ];
  }

  dispose() {
    textController.dispose();
    textFocusNode.dispose();
  }

  _initFineTune() {
    final bool isGirl = ref.read(userInfoProvider).memberInfo?.gender == 0;
    if(isGirl) {
      fineTuneList = ['像是20歲少男的回复風格，回复內容自然只需要單純聊天內容不要具有疑問句'];
    } else {
      fineTuneList = ['像是20歲少女的回复風格，回复內容自然只需要單純聊天內容不要具有疑問句'];
    }
//
    fineTuneList?.add('內容不能帶有不雅字眼與涉及情色或是任何諧音試圖涉及違規內容的字眼');
    fineTuneList?.add('內容不能帶有政治議題內容或是設計任何政治人物或議題的內容');
    fineTuneList?.add('具有違規內容或政治議題統一回复罐頭訊息：对不起，内容带有违规字眼。');
  }

  String _getContentMsg({
    required String uuid,
    required String msg
}) {
    /// content
    final Map<String, dynamic> contentJson = {
      "uuid": uuid,
      "type": 0, "gift_id": "", "gift_count": "", "gift_url": "", "gift_name": "",
      "content": msg,
    };
    final String contentJsonStr = json.encode(contentJson);
    return contentJsonStr;
  }

  String _getExtendDataMsg({
    required String uuid,
    required bool isMe
  }) {
    /// extendData
    final Map<String, dynamic> extendDataJson = {
      "remainCoins": null,
      "expireTime": 0, "halfTime": 0, "points": 0, "incomeflag": 0,
      "uuid": uuid,
      "expireDuration": 0,"halfDuration": 0,
      "isMe": isMe
    };
    final String extendDataJsonStr = json.encode(extendDataJson);
    return extendDataJsonStr;
  }

  sendMsg({
    required String msg,
    required bool isMe
  }) {
    final String uuid = const Uuid().v4();
    final String content = _getContentMsg(uuid: uuid, msg: msg);
    final String extendData = _getExtendDataMsg(uuid: uuid, isMe: isMe);
    final ZIMTextMessage zimTextMessage = ZIMTextMessage(message: content)
    ..extendedData = extendData
    ..timestamp = DateTime.now().millisecondsSinceEpoch;
    chatList.add(zimTextMessage);

    if(isMe) {
      textController.text = '';
      _sendAi(msg);
    }
    setState((){});
  }

  _sendAi(String messageText) async {
    final resObj = await AiChatManager.sendMessage(
      messageText: messageText,
      fineTuneList: []
    );
    final String resText = resObj?.choices.first.message.content?.first.text ?? '';
    sendMsg(msg: resText, isMe: false);
  }

  _onTapTrivia() {
    final int index = AiConstant.triviaList.length;
    final int random = Random().nextInt(index);
    sendMsg(msg: AiConstant.triviaList[random], isMe: false);
  }

  _onTapFate() {
    final int index = AiConstant.fateList.length;
    final int random = Random().nextInt(index);
    sendMsg(msg: AiConstant.fateList[random], isMe: false);
  }

  _ontTapTest1() {
    optionTitle = '你更喜欢哪种颜色？';
    optionModelList = test1;
    setState((){});
  }

  _test2() {
    optionTitle = '如果你是一只猫，你会更喜欢在哪里度过大部分时间？';
    optionModelList = test2;
    setState((){});
  }

  _test3() {
    optionTitle = '选择下面哪一种猫咪的表情最能代表你今天的心情？';
    optionModelList = test3;
    setState((){});
  }

  _testResult() {
    final int index = AiConstant.testResultList.length;
    final int random = Random().nextInt(index);
    sendMsg(msg: AiConstant.testResultList[random], isMe: false);
  }
}