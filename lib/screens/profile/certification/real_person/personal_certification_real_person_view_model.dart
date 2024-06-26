

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/req/account_modify_user_req.dart';
import 'package:frechat/models/req/upload_real_person_img_req.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/image_picker_util.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/shared/pip/pip.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:image_cropper/image_cropper.dart';


class PersonalCertificationRealPersonViewModel {
  PersonalCertificationRealPersonViewModel({required this.ref, required this.setState});
  WidgetRef ref;
  ViewChange setState;

  init() {
  }

  dispose() {

  }

  Future<void> changeUserImg(BuildContext context, {
    required Function() onShowFrequentlyDialog
  }) async {
    AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    //防止連續登入問題 (裁圖/照相功能會造成斷線)
    if (ref.read(commApiProvider).isLegalForNextLogin()) {
      final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
      if (isPipMode) {
        CommDialog(context).build(
          theme: theme,
          title: '提醒',
          contentDes: '您现在正在通话中，无法进行真人认证',
          rightBtnTitle: '确定',
          rightAction: () {
            BaseViewModel.popupDialog();
            BaseViewModel.popPage(context);
          },
        );
        return;
      }

      /// 更換頭像
      final XFile? xFile = await ImagePickerUtil.selectImage();
      final CroppedFile? croppedFile = await ImagePickerUtil.cropImage(xFile);
      if (croppedFile != null) {
        // loading
        if(context.mounted) LoadingAnimation.showOverlayDotsLoading(context, appTheme: theme);

        final resultImage = File(croppedFile.path);
        final commToken = ref.read(userInfoProvider).commToken;
        String? resultCodeCheck;
        MemberModifyUserReq req = MemberModifyUserReq.create(
          tId: commToken ?? 'emptyToken',
          avatarImg: resultImage,
        );

        await ref.read(commApiProvider).memberModifyUser(
            req,
            onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
            onConnectFail: (errMsg) {
              // loading
              LoadingAnimation.cancelOverlayLoading();

              try {
                BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
              } catch (e) {
                BaseViewModel.showToast(context, '亲～图片格式错误');
              }
            }
        );

        if(resultCodeCheck == ResponseCode.CODE_SUCCESS) {
          if(context.mounted) {
            await _loadMemberInfo(context);
          }

          if(context.mounted) {
            BaseViewModel.popPage(context);
            BaseViewModel.popPage(context);
          }

          LoadingAnimation.cancelOverlayLoading();
        }
      }
      setState((){});
    } else {
      onShowFrequentlyDialog();
    }
  }

  Future<void> takePicFrontCamera(BuildContext context, {
    required Function() onShowFrequentlyDialog
  }) async {
    //防止連續登入問題 (裁圖/照相功能會造成斷線)
    if (ref.read(commApiProvider).isLegalForNextLogin()) {
      final bool isPipMode = PipUtil.pipStatus == PipStatus.piping;
      if (isPipMode) {
        final AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

        CommDialog(context).build(
          theme: theme,
          title: '提醒',
          contentDes: '您现在正在通话中，无法进行真人认证',
          rightBtnTitle: '确定',
          rightAction: () {
            BaseViewModel.popupDialog();
            BaseViewModel.popPage(context);
          },
        );
        return;
      }
      /// 檢查是否有頭像
      final num avatarAuth = ref.read(userInfoProvider).memberInfo?.avatarAuth ?? 0;
      final type = CertificationModel.getType(authNum: avatarAuth);
      if(type != CertificationType.done) {
        BaseViewModel.showToast(context, '须先进行头像审核才能刷脸认证');
        return ;
      }

      /// 拍照認證
      XFile? xFile = await ImagePickerUtil.takePicFrontCamera();
      if(xFile == null) {
        return ;
      }
      if(context.mounted) {
        final CroppedFile? croppedFile = await ImagePickerUtil.cropImage(xFile);
        if (croppedFile != null) {
          final resultImage = File(croppedFile.path);
          if(context.mounted) {
            uploadRealPersonImg(context, imgPath: resultImage);
          }
        }
      }
    } else {
      onShowFrequentlyDialog();
    }
  }

  Future<void> uploadRealPersonImg(BuildContext context,{File? imgPath}) async {
    final UserInfoModel userInfo = ref.read(userInfoProvider);
    final AppTheme theme = userInfo.theme ?? AppTheme(themeType: AppThemeType.original);
    LoadingAnimation.showOverlayDotsLoading(context, appTheme: theme);
    if(imgPath == null) {
      BaseViewModel.showToast(context, '头像资料不能为空');
      LoadingAnimation.cancelOverlayLoading();
      return ;
    }
    final String token = userInfo.commToken ?? 'emptyToken';
    final UploadRealPersonImgReq reqBody = UploadRealPersonImgReq.create(tId: token, realPersonImg: imgPath!);
    ref.read(commApiProvider).uploadRealPersonImg(reqBody,
      onConnectSuccess: (succMsg) async {
        await _loadMemberInfo(context);
        if (context.mounted) {
          BaseViewModel.popPage(context);
          BaseViewModel.popPage(context);
          LoadingAnimation.cancelOverlayLoading();
        }
      },
      onConnectFail: (errMsg) {
        BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
        LoadingAnimation.cancelOverlayLoading();
      },
    );
  }

  Future<void> _loadMemberInfo(BuildContext context) async {
    String? resultCodeCheck;
    final reqBody = WsMemberInfoReq.create();
    final WsMemberInfoRes res = await ref.read(memberWsProvider).wsMemberInfo(
        reqBody,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) => BaseViewModel.showToast(context, errMsg)
    );
    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      ref.read(userUtilProvider.notifier).loadMemberInfo(res);
    }
  }
}