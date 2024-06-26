import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/system/constant/enum.dart';

import 'package:frechat/system/extension/string.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/audio_util.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

import '../../../system/repository/http_setting.dart';

BoxDecoration shadowDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(17),
    gradient: AppColors.pinkLightGradientColors,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 0,
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );
}

class UserInfoPlayBt extends ConsumerStatefulWidget {

  final String? audioPath;

  const UserInfoPlayBt({
    super.key,
    this.audioPath
  });

  @override
  UserInfoPlayBtState createState() => UserInfoPlayBtState();
}

class UserInfoPlayBtState extends ConsumerState<UserInfoPlayBt> {

  int audioTime = 0;
  bool isAudioPlay = false;

  @override
  void initState() {
    getAudioTime();
    super.initState();
  }

  @override
  void dispose() {
    AudioUtils.stopPlaying();
    super.dispose();
  }

  // 取得錄音時間
  void getAudioTime() async {
    final time = await AudioUtils.getAudioTime(audioUrl: '${widget.audioPath}', addBaseImagePath: true);
    final num? seconds = time?.toString().split(':')[2].toNum();
    audioTime = seconds!.ceil();
    setState(() {});
  }

  // 播放錄音
  void playAudio() async {
    if (isAudioPlay) {
      AudioUtils.stopPlaying();
      playHandler();
      return;
    }

    playHandler();
    AudioUtils.startPlayingFromUrl(
            audioUrl: '${HttpSetting.baseImagePath}${widget.audioPath}')
        .then((value) {
      playHandler();
    });
  }

  // 狀態處理
  void playHandler() {
    isAudioPlay = !isAudioPlay;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppImageTheme appImageTheme = theme.getAppImageTheme;
    final AppBoxDecorationTheme appBoxDecorationTheme = theme.getAppBoxDecorationTheme;
    final AppTextTheme appTextTheme = theme.getAppTextTheme;

    return GestureDetector(
      onTap: () => playAudio(),
      child: Container(
        width: 60.w,
        height: 32.h,
        decoration: appBoxDecorationTheme.userInfoViewAudioBoxDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImgUtil.buildFromImgPath(isAudioPlay
                ? appImageTheme.iconUserInfoViewAudioPause
                : appImageTheme.iconUserInfoViewAudioPlay, size: 16.w
            ),
            SizedBox(width: 3.w),
            Text(
              '${audioTime == 0 ? '' : audioTime}s',
              style: appTextTheme.userInfoViewAudioTextStyle
            ),
          ],
        ),
      ),
    );
  }
}
