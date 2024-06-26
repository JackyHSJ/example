
import 'package:flutter/material.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

class SvgaPlayerUtil{
  static SVGAAnimationController? animationController;

  static init(TickerProvider tickerProvider){
    animationController = SVGAAnimationController(vsync: tickerProvider);
  }


  static void loadAnimation(String url) async {
    final videoItem = await SVGAParser.shared.decodeFromURL(url);
    animationController!.videoItem = videoItem;
    animationController!.forward(from: 0);
    animationController!.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        print('start');
      }
      // 如果動畫已完成
      if (status == AnimationStatus.completed) {
        // 執行一些操作
        animationController!.videoItem = null;
        print('The animation is over.');
      }
    });
  }

}