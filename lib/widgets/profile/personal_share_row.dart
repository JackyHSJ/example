
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/deep_link_model.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/screens/profile/invite_friend/personal_invite_friend_qrcode.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/payment/wechat/wechat_manager.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/share_util.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
// import 'package:social_share_plus/social_share.dart';
import 'package:wechat_kit/wechat_kit.dart';

class PersonalShareRow extends ConsumerStatefulWidget {
  const PersonalShareRow({
    super.key,
    required this.type
  });
  final InviteFriendType type;

  @override
  ConsumerState<PersonalShareRow> createState() => _PersonalDataState();
}

class _PersonalDataState extends ConsumerState<PersonalShareRow> {

  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppTextTheme _appTextTheme;

  InviteFriendType get type => widget.type;

  @override
  Widget build(BuildContext context) {

    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appTextTheme = _theme.getAppTextTheme;


    return Container(
      margin: EdgeInsets.only(top: 16.h, bottom: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton(_appImageTheme.promotionCenterIconlink, '分享链接', onTap: () => shareInviteCode(context)),
          const SizedBox(width: 16),
          _buildButton(_appImageTheme.promotionCenterIconQrcode, '二维分享', onTap: () => _showDialog()),
          /// Review 環境隱藏
          // const SizedBox(width: 16),
          // _buildButton(_appImageTheme.promotionCenterIconWechatFreind, '微信好友', onTap: () => shareWechatWebPage(sense: WechatScene.kSession, type: type)),
          // const SizedBox(width: 16),
          // _buildButton(_appImageTheme.promotionCenterIconWechatMoments, '朋友圈', onTap: () => shareWechatWebPage(platform: SharePlatforms.wechatTimeline)),
        ],
      ),
    );
  }

  _buildButton(String imagePath, String title, {required Function() onTap}){
    return InkWell(
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle, color: _appColorTheme.promotionCenterChannelButtonBackgroundColor),
            child: Image(
              width: 24,
              height: 24,
              image: AssetImage(imagePath),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(title, style: _appTextTheme.labelPrimaryContentTextStyle),
        ],
      ),
      onTap: () => onTap(),
    );
  }


  // 分享
  void shareInviteCode(BuildContext context) {
    final UserInfoModel userInfo = ref.read(userInfoProvider);

    String inviteCode = '';
    String agentName = userInfo.memberInfo?.agentName ?? '';
    String userName = userInfo.memberInfo?.userName ?? '';

    if (type == InviteFriendType.agent) {
      inviteCode = agentName;
    } else if (type == InviteFriendType.contact) {
      inviteCode = userName;
    }

    final String nickName = userInfo.memberInfo?.nickName ?? inviteCode;
    String deepLinkUri = AppConfig.getDeepLinkUri;

    final String inviteUri = DeepLinkModel(
      inviteCode: inviteCode,
      name: '',
      avatar: '',
    ).createUrl('$deepLinkUri/');
    ShareUtil.shareText(context, inviteUri, subDes: nickName);
  }

  // Future<void> shareWechatWebPage ({
  //   required SharePlatform platform, // WechatScene.kSession
  //   required InviteFriendType type,
  // }) async {
  //   final UserNotifier userUtil = ref.read(userUtilProvider.notifier);
  //   final String appIconPath = ref.read(userInfoProvider).theme?.getAppImageTheme.wechatShareAppIcon ?? '';
  //   await ShareUtil.shareWechatWebPage(
  //     platform: platform,
  //     userUtil: userUtil,
  //     appIcon: appIconPath,
  //     type: type,
  //   );
  // }

  Future<void> shareWechatWebPage ({
    required int sense, // WechatScene.kSession
    required InviteFriendType type,
  }) async {
    final UserNotifier userUtil = ref.read(userUtilProvider.notifier);
    final String appIconPath = ref.read(userInfoProvider).theme?.getAppImageTheme.wechatShareAppIcon ?? '';
    final ByteData data = await rootBundle.load(appIconPath);
    final Uint8List appIconBytes = data.buffer.asUint8List();
    await WeChatManager.shareWebPage(
      scene: sense,
      userUtil: userUtil,
      appIcon: appIconBytes,
      type: type,
    );
  }

  // QR code 彈窗
  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return InviteFriendQrcodeDialog(type: type);
      },
    );
  }
}
