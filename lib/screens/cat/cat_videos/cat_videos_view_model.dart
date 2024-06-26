

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/cat/cat_videos/model/videos_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/widgets/theme/uidefine.dart';

class CatVideosViewModel {
  CatVideosViewModel({required this.setState, required this.ref});
  ViewChange setState;
  WidgetRef ref;

  List<VideosModel> videosList = [
    VideosModel(
      videosUrl: 'https://s3.cn-north-1.amazonaws.com.cn/mtab.kezaihui.com/video/ForBiggerBlazes.mp4',
      avatarPath: '',
      name: 'Jacky',
      title: 'tack a pic.',
      des: 'Im so glad to share my life.',
      isSubscribe: false,
    ),
    VideosModel(
      videosUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      avatarPath: '',
      name: 'Jerry',
      title: 'looking my cat',
      des: 'so cute',
      isSubscribe: false,
    ),
    VideosModel(
      videosUrl: 'http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4',
      avatarPath: '',
      name: 'Xuan',
      title: 'hello everyone',
      des: 'my son',
      isSubscribe: false,
    ),
    VideosModel(
      videosUrl: 'https://s3.cn-north-1.amazonaws.com.cn/mtab.kezaihui.com/video/ForBiggerBlazes.mp4',
      avatarPath: '',
      name: 'Alexson',
      title: '2023',
      des: 'good for today',
      isSubscribe: false,
    ),
    VideosModel(
      videosUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      avatarPath: '',
      name: 'tina W',
      title: 'great!',
      des: 'Im so happy to share my part of my world.',
      isSubscribe: false,
    ),
  ];

  init() {
  }

  dispose() {
  }
}