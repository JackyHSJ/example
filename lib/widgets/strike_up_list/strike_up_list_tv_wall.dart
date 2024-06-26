import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import '../../screens/strike_up_list/how2tv/strike_up_list_how2tv.dart';
import '../../system/base_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StrikeUpListTvWall extends ConsumerStatefulWidget {

  final String who;
  final String whom;
  final String gift;
  final String image;
  final num amount;

  const StrikeUpListTvWall({
    super.key,
    required this.who,
    required this.whom,
    required this.gift,
    required this.image,
    required this.amount,
  });

  @override
  ConsumerState<StrikeUpListTvWall> createState() => _StrikeUpListTvWallState();
}

class _StrikeUpListTvWallState extends ConsumerState<StrikeUpListTvWall> {
  AppTheme? theme;
  late AppTextTheme appTextTheme;
  late AppImageTheme appImageTheme;
  late AppColorTheme appColorTheme;


  // 名稱太長取前 maxLength 個字加上 ...
  String truncateString(String input, int maxLength) {
    if (input.length <= maxLength) {
      return input;
    } else {
      return "${input.substring(0, maxLength)}...";
    }
  }

  @override
  Widget build(BuildContext context) {
    theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appTextTheme = theme!.getAppTextTheme;
    appColorTheme = theme!.getAppColorTheme;
    appImageTheme = theme!.getAppImageTheme;

    return SizedBox(
      height: 58.h,
      child: Stack(
        children: [
          Row(
            children: [
              _buildAvatar(),
              SizedBox(width: 12.w),
              Expanded(child: _buildContent()),
              SizedBox(width: 12.w),
            ],
          ),
          _buildHowToTv(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {

    // return Container(height: 40.h,width: 40.h,color: Colors.amber);
    if (widget.image.contains('http')) {
      return CachedNetworkImageUtil.load(widget.image, size: 40.h, radius: 6);
    } else {
      return AvatarUtil.localAvatar(widget.image, size: 40.h, radius: 6);
    }
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRichText(),
        SizedBox(height: 5.h),
        Text(
          '一起祝福他们吧....👏🏼👏🏼👏🏼👏🏼',
          style: appTextTheme.strikeUpListMarqueeDefaultTextStyle,
        ),
      ],
    );

  }

  Widget _buildRichText() {

    final String sender = truncateString(widget.who ?? '', 4);
    final String receiver =truncateString( widget.whom ?? '', 4);
    final num amount = widget.amount ?? 0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: RichText(
        text: TextSpan(
          text: '$sender ',
          style: appTextTheme.strikeUpListMarqueeTextStyle,
          children: <TextSpan>[
            TextSpan(
              text: '送给 ',
              style: appTextTheme.strikeUpListMarqueeDefaultTextStyle,
            ),
            TextSpan(
              text: '$receiver ',
              style: appTextTheme.strikeUpListMarqueeTextStyle,
            ),
            TextSpan(
              text: '$amount 个 ',
              style: appTextTheme.strikeUpListMarqueeDefaultTextStyle,
            ),
            TextSpan(
              text: widget.gift,
              style: appTextTheme.strikeUpListMarqueeTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowToTv() {

    return Positioned(
      right: 0,
      bottom: 10.h,
      child: GestureDetector(
        onTap: () {
          BaseViewModel.pushPage(context, const StrikeUpListHowToTv());
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImgUtil.buildFromImgPath(appImageTheme.howToTv, size: 12.w),
            SizedBox(width: 4.w),
            Text('如何上电视', style: appTextTheme.howToTvTextStyle),
            SizedBox(width: 4.w),
            ImgUtil.buildFromImgPath(appImageTheme.howToTvArrow, size: 12.w),
          ],
        ),
      ),
    );
  }
}
