import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/assets_path/assets_images_path.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/widgets/strike_up_list/strike_up_list_extension.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../../system/call_back_function.dart';
import '../../widgets/strike_up_list/strike_up_list_tv_wall.dart';

class StrikeUpListMarqueeViewModel {

  WidgetRef ref;
  ViewChange setState;
  BuildContext context;

  StrikeUpListMarqueeViewModel({
    required this.setState,
    required this.ref,
    required this.context
  });

  Timer? _timer;
  Function()? func;
  List<Widget> playList = [];
  double height = 58.h;
  double offset = 0;
  ScrollController? scrollController;
  int remove = 0;
  bool show = false;
  int index = 0;
  List<num> sec = [3, 3, 3];
  List<String> flag = ['0', '0', '0'];
  bool check = false;
  List defaultGiftNameTexts = [];

  init() {
    iniTvWallList();
    scrollController = ScrollController();
  }

  iniTvWallList() async {

    AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    AppImageTheme appImageTheme = theme.getAppImageTheme;

    List<String> man = ['神秘人', '神秘人', '神秘人'];
    List<String> wman = ['神秘人', '神秘人', '神秘人'];
    List<String> imageList = [
      appImageTheme.iconAppSmall,
      appImageTheme.iconAppSmall,
      appImageTheme.iconAppSmall,
    ];

    String data = '';
    data = await rootBundle.loadString('assets/txt/gift_name.txt');
    defaultGiftNameTexts = const LineSplitter().convert(data);
    List<num> amountList = [1,1,1];
    List<StrikeUpListTvWall> tvWallList = generateRandomPairings(man, wman, imageList, amountList);
    playList = [];
    for (var item in tvWallList) {
      playList.add(item);
    }
    playList.add(SizedBox(height: height));
  }

  ///隨機跑馬燈資料
  List<StrikeUpListTvWall> generateRandomPairings(List<String> maleNames, List<String> femaleNames, List<String> imageList, List<num> amountList) {
    List<StrikeUpListTvWall> pairings = [];

    //maleNames.shuffle();
    //femaleNames.shuffle();

    int pairingCount = min(maleNames.length, femaleNames.length);
    for (int i = 0; i < pairingCount; i++) {
      pairings.add(StrikeUpListTvWall(
        who: maleNames[i],
        whom: femaleNames[i],
        gift: defaultGiftNameTexts[Random().nextInt(defaultGiftNameTexts.length)],
        image: imageList[i],
        amount: amountList[i],
      ));
    }

    return pairings;
  }

  addTvData(String? who, String? whom, String? gift, num? duration, String fromUserAvatar, int? fromUserGender, num amount, {String? image}) {
    AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    AppImageTheme appImageTheme = theme.getAppImageTheme;
    if (!show) return;

    String showUserAvatar = '';

    if (fromUserAvatar.isEmpty) {
      showUserAvatar = fromUserGender == 0 ? appImageTheme.defaultFemaleAvatar :  appImageTheme.defaultMaleAvatar;
    } else {
      showUserAvatar = HttpSetting.baseImagePath + fromUserAvatar;
    }

    // -1 代表是匿名
    if (fromUserGender == -1) {
      showUserAvatar = appImageTheme.iconAppSmall;
    }

    final sult = StrikeUpListTvWall(
      who: who ?? '',
      whom: whom ?? '',
      gift: gift ?? '',
      image: showUserAvatar,
      amount: amount,
    );
    playList.insert(3 + remove, sult);
    flag.insert(3, '1');
    num secnum = duration ?? 0;
    if (secnum < 3) {
      secnum = 3;
    }
    sec.insert(3 + remove, secnum);
    remove++;
  }

  void start(ViewChange setState) {
    show = true;
    scrollController?.animateTo(offset, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    setState(() {
      offset += height;
      Future.delayed(const Duration(milliseconds: 350), () {
        if (offset >= (height * (playList.length))) {
          index = 0;
          offset = height;
          scrollController?.jumpTo(0 - height);
          if (remove > 0) {
            do {
              check = false;
              for (int i = 0; i < flag.length; i++) {
                if (flag[i] == '2') {
                  remove--;
                  playList.removeAt(i);
                  sec.removeAt(i);
                  flag.removeAt(i);
                  check = true;
                  break;
                }
              }
            } while (check);
            /*
            for (int i = 0; i < flag.length; i++) {
              if (flag[i] == '2') {
                remove--;
                playList.removeAt(i);
                sec.removeAt(i);
              }
            }
            */
          }
        }
      });
    });
    //try{}catch()
    _timer = Timer.periodic(Duration(seconds: sec[index].toInt()), (timer) {
      if (flag[index] == '1') {
        flag[index] = '2';
      }
      // print('${sec.length}/$index:延遲${sec[index]}秒後執行');
      _timer?.cancel();
      if ((sec.length > (index + 1))) {
        index++;
      }

      start(setState);
    });
  }

  //int get seconds => _seconds;
  void stop() {
    scrollController?.dispose();
    show = false;
    _timer?.cancel();
  }
}
