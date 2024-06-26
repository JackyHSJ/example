import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/deep_link_model.dart';
import 'package:frechat/system/app_config/app_config.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/system/util/permission_util.dart';
import 'package:frechat/system/zego_call/utils/permission_io.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pasteboard/pasteboard.dart';


//邀请朋友彈窗
class InviteFriendQrcodeDialog extends ConsumerStatefulWidget {
  const InviteFriendQrcodeDialog({super.key, required this.type});
  final InviteFriendType type;

  @override
  _InviteFriendQrcodeDialogState createState() => _InviteFriendQrcodeDialogState();
}

class _InviteFriendQrcodeDialogState extends ConsumerState<InviteFriendQrcodeDialog> {
  GlobalKey qrKey = GlobalKey();
  InviteFriendType get type => widget.type;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: RepaintBoundary(
            key: qrKey,
            child: Stack(
              children: [contentWidget(), bannerWidget()],
            ),
          ),
          onLongPress: () async {
            // _copyImageToClipboard();
          },
        ),
        cancelWidget()
      ],
    );
  }

  //關閉按鈕
  Widget cancelWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: GestureDetector(
        child: Image(
          width: 36.w,
          height: 36.h,
          image: const AssetImage('assets/images/button_cancel.png'),
        ),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  //大圖橫幅
  Widget bannerWidget() {
    return Container(
      margin: EdgeInsets.only(top: 103.h, left: 46.w, right: 46.w),
      child: Image(
        width: MediaQuery.of(context).size.width,
        image: const AssetImage('assets/images/invent_qrcode_banner.png'),
      ),
    );
  }

  // 內容
  Widget contentWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 343.w,
              height: 512.h,
              margin: EdgeInsets.only(top: 146.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                image: const DecorationImage(
                  image: AssetImage('assets/images/invent_qrcode_bg.png'),
                  fit: BoxFit.cover, // 填充方式
                ),
              ),
              child: Column(
                children: [myselfInformationWidget(), qrCodeImageView(), saveToAlbumButton()],
              )),
        ],
      ),
    );
  }

  //保存到相簿按鈕
  Widget saveToAlbumButton() {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 36.h),
        padding: EdgeInsets.symmetric(horizontal: 90.w, vertical: 12.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: AppColors.pinkLightGradientColors),
        child: Text("保存到相册",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              decoration: TextDecoration.none,
            )),
      ),
      onTap: () {
        saveToGallery();
      },
    );
  }

  //保存到相簿
  Future<void> saveToGallery() async {

    bool result = await PermissionUtil.checkAndRequestStoragePermission();
    if (!result) return;

    // 权限已授予，执行保存操作
    try {
      await Future.delayed(const Duration(milliseconds: 100)); // 添加延迟
      RenderRepaintBoundary boundary = qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 5.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);

      final result = await ImageGallerySaver.saveImage(
        byteData!.buffer.asUint8List(),
        quality: 100,
        name: 'qr_code',
      );
      if (result['isSuccess']) {
        toast('已保存到相册');
      } else {
        toast('保存失败');
      }
    } catch (e) {
      print('保存失败：$e');
      toast('保存失败');
    }
  }

  //複製圖片
  void _copyImageToClipboard() async {
    try {
      RenderRepaintBoundary boundary = qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 1.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      if (byteData != null) {
        final byteDataList = byteData.buffer.asUint8List();
        final base64String = base64Encode(byteDataList);
        //測試
        final data = base64Decode(base64String);
        Pasteboard.writeImage(data);
        // Clipboard.setData(ClipboardData(text: base64String));
        toast('已复制到剪贴簿');
      }
    } catch (e) {
      print('复制失败：$e');
      toast('复制失败');
    }
  }

  Future<String> saveImageToFile(final image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/image.png';
    await File(filePath).writeAsBytes(buffer);
    return filePath;
  }

  //Toast彈窗
  void toast(String text) {
    BaseViewModel.showToast(context, text);
  }

  //Qrcode圖片
  Widget qrCodeImageView() {

    String inviteCode = '';
    String agentName = ref.read(userInfoProvider).memberInfo?.agentName ?? '';
    String userName = ref.read(userInfoProvider).memberInfo?.userName ?? '';

    if (type == InviteFriendType.agent) {
      inviteCode = agentName;
    } else if (type == InviteFriendType.contact) {
      inviteCode = userName;
    }
    String deepLinkUri = AppConfig.getDeepLinkUri;

    final String inviteUri = DeepLinkModel(
      inviteCode: inviteCode,
      avatar: '',
      name: '',
    ).createUrl('$deepLinkUri/');

    return Container(
      margin: EdgeInsets.only(top: 20.h, right: 72.w, left: 72.w),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        border: Border.all(width: 1, color: AppColors.mainLightGrey),
      ),
      child: Center(
        child: QrImageView(
          data: inviteUri,
          version: QrVersions.auto,
          size: 215.h,
        ),
      ),
    );
  }


  //我的資訊
  Widget myselfInformationWidget() {
    return Container(
      margin: EdgeInsets.only(left: 56.w, top: 109.h),
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            avatarWidget(),
            const SizedBox(width: 10),
            myselfInformationDetailWidget(),
          ],
        ),
      )
    );
  }

  // 自己頭像
  Widget avatarWidget() {

    final avatarPath = ref.read(userInfoProvider).memberInfo?.avatarPath ?? '';
    final gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;

    return (avatarPath == '')
        ? AvatarUtil.defaultAvatar(gender, size: 48.w)
        : AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatarPath, size: 48.w);
  }

  // 詳細資料
  Widget myselfInformationDetailWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [myselfInformationNameWidget(), ageAndCharm()],
    );
  }

  //名稱＋VIP(VIP未來新增)
  Widget myselfInformationNameWidget() {
    final String userName = ref.read(userInfoProvider).userName ?? '';
    final String nickName = ref.read(userInfoProvider).nickName ?? userName;
    return Row(
      children: [
        Material(
          type: MaterialType.transparency,
          child: Text(
            nickName,
            style: TextStyle(color: Colors.red, fontSize: 20.sp, fontWeight: FontWeight.w700),
          ),
        )
      ],
    );
  }

  // 年齡和魅力值
  Widget ageAndCharm() {
    return Row(
      children: [
        ageWidget(),
        const SizedBox(width: 4),
        charmWidget()
      ],
    );
  }

  // 年齡 Label
  Widget ageWidget() {

    final age = ref.read(userInfoProvider).memberInfo?.age ?? 0;
    final gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;

    return Container(
      height: 16,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99.0),
          color: (gender == 0)
              ? const Color(0xFFFD73A5)
              : const Color(0xFF54B5DF)),
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 6),
        child: Row(
          children: [
            Image.asset('assets/profile/profile_contact_${gender == 0 ? 'female' : 'male'}_icon.png', width: 12, height: 12),
            const SizedBox(width: 2),
            Text('$age',style: const TextStyle(color: Color(0xFFFFFFFF),fontSize: 10.0,fontWeight: FontWeight.w500,height: 1,decoration: TextDecoration.none)),
          ],
        ),
      ),
    );
  }

  // 魅力值 Label
  Widget charmWidget() {

    final charmLevel = ref.read(userInfoProvider).memberInfo?.charmLevel ?? 0;
    final gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;

    return Visibility(
      visible: gender == 0,
      child: Container(
        height: 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99.0),
          color: const Color(0xFFFD73A5),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF37AFF3), Color(0xFFCD9DFB)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 4, right: 6),
          child: Row(
            children: [
              Image.asset('assets/profile/profile_contact_heart_white_icon.png', width: 12, height: 12),
              const SizedBox(width: 2),
              Text('$charmLevel',style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 10.0, fontWeight: FontWeight.w500, height: 1,decoration: TextDecoration.none)),
            ],
          ),
        ),
      ),
    );
  }
}
