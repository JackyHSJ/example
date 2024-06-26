

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/util/video_player_util.dart';

class VideosWallCellViewModel {
  VideosWallCellViewModel({required this.setState, required this.ref});
  ViewChange setState;
  WidgetRef ref;

  VideoPlayerUtil? playerUtil;


  init(BuildContext context) async {
    playerUtil = VideoPlayerUtil();
    List<String> videoList =[];
    String env = await FcPrefs.getEnv();
    if(env == AppEnvType.QA.name){
      videoList = ['https://pic.yuanyuqa.com/video/001.mp4','https://pic.yuanyuqa.com/video/002.mp4','https://pic.yuanyuqa.com/video/003.mp4','https://pic.yuanyuqa.com/video/004.mp4','https://pic.yuanyuqa.com/video/005.mp4'];

    }else{
      videoList = ['https://pic.gscjcplive.com/video/001.mp4','https://pic.gscjcplive.com/video/002.mp4','https://pic.gscjcplive.com/video/003.mp4','https://pic.gscjcplive.com/video/004.mp4','https://pic.gscjcplive.com/video/005.mp4'];
    }
    Random random = Random();
    // 生成指定范围内的随机整数（例如，生成1到10之间的整数）
    // int min = 0;
    // int max = 1;
    // int randomInteger = min + random.nextInt(max - min + 1);

    playerUtil?.init(url: videoList[random.nextInt(videoList.length)]);
    playerUtil?.setFinishCallback(callback: (){
      if(context.mounted) {
        setState((){});
      }
    });
  }

  dispose() {
    // pause();
    playerUtil?.dispose();
  }

  bool isPlay() {
    return playerUtil?.isPlaying() ?? false;
  }

  play() {
    playerUtil?.play();
  }

  pause() {
    playerUtil?.pause();
  }
}