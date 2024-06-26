

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/models/ws_res/report/ws_report_search_type_res.dart';
import 'package:frechat/screens/activity/activity_post_detail.dart';
import 'package:frechat/screens/activity/tab/recommend/activity_recommend_tab.dart';
import 'package:frechat/system/assets_path/assets_images_path.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/recharge_util.dart';
import 'package:frechat/system/util/touch_feedback_util.dart';
import 'package:frechat/widgets/activity/activity_report_dialog.dart';
import 'package:frechat/widgets/activity/cell/activity_post_cell_view_model.dart';
import 'package:frechat/widgets/shared/bottom_sheet/common_bottom_sheet.dart';
import 'package:frechat/widgets/shared/bottom_sheet/recharge/recharge_bottom_sheet.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:frechat/widgets/shared/dialog/base_dialog.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:vibration/vibration.dart';


class ActivityPostCellActions extends ConsumerStatefulWidget {
  const ActivityPostCellActions({super.key, required this.postInfo, required this.viewModel, required this.likeList,required this.onTapMessageButton});
  final ActivityPostInfo postInfo;
  final ActivityPostCellViewModel viewModel;
  final List<dynamic> likeList;
  final Function() onTapMessageButton;
  @override
  ConsumerState<ActivityPostCellActions> createState() => _ActivityPostCellActionsState();
}

class _ActivityPostCellActionsState extends ConsumerState<ActivityPostCellActions> with SingleTickerProviderStateMixin{
  ActivityPostInfo get postInfo => widget.postInfo;
  ActivityPostCellViewModel get viewModel => widget.viewModel;
  List<dynamic> get likeList => widget.likeList;
  late final AnimationController _donatAnimationController;

  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;
  DateTime? _lastOnTapLikeButtonTime;

  /// 顯示更多功能底部彈窗
  void _showMoreBottomDialog() {

    final String postInfoUserName = postInfo.userName ?? '';
    final num userId = postInfo.userId ?? 0;
    final num replyId = postInfo.id ?? 0;
    final String personalUserName = ref.read(userInfoProvider).memberInfo?.userName ?? '';

    String title = '';
    title = postInfoUserName == personalUserName ? '刪除' : '举报';

    CommonBottomSheet.show(context,
      title: '针对此贴文',
      actions: [
        CommonBottomSheetAction(
          title: '$title',
          titleStyle: const TextStyle(
              fontSize: 16,
              color: Color(0xFFFF3B30),
              fontWeight: FontWeight.w400
          ),
          onTap: () {
            BaseViewModel.popPage(context);
            if (title == '刪除') {
              _showDeleteDialog(replyId);
            } else {
              _showReportDialog(userId, replyId);
            }
          },
        ),
      ],
    );
  }

  /// 顯示更多功能底部彈窗 - 顯示舉報彈窗
  void _showReportDialog(num userId, num feedId){
    BaseDialog(context).showTransparentDialog(
      isDialogCancel: true,
      widget: ActivityReportDialog(
        title: '举报此貼文',
        onTap: (ReportListInfo reportListInfo, String reportText) {
          _onTapReportPostButton(feedId, reportListInfo, reportText, userId);
        },
      ),
    );
  }

  /// 顯示更多功能底部彈窗 - 顯示刪除
  void _showDeleteDialog(num feedsId) {
    CommDialog(context).build(
      theme: _theme,
        title: '提醒',
        contentDes: '确定要删除动态吗',
        leftBtnTitle: '取消',
        leftAction: () => BaseViewModel.popPage(context),
        rightBtnTitle: '确认',
        rightAction: () {
          _onTapDeletePostButton(feedsId);
        }
    );
  }

  // 充值彈窗
  void rechargeHandler() {
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final num rechargeCounts =  ref.read(userInfoProvider).memberPointCoin?.depositCount ?? 0;
    if (rechargeCounts == 0) {
      RechargeUtil.showFirstTimeRechargeDialog('打赏动态金额不足'); // 開啟首充彈窗
    } else {
      RechargeUtil.showRechargeBottomSheet(theme: theme); // 開啟充值彈窗
    }
  }

  /// 顯示舉報確認彈窗
  void _showReportPostConfirmDialog() {
    CommDialog(context).build(
      theme: _theme,
      title: '已收到举报',
      contentDes: '官方将在审核后于消息通知裁定结果，请耐心等候',
      rightBtnTitle: '确认',
      rightAction: () {
        BaseViewModel.popPage(context);
        BaseViewModel.popPage(context);
      }
    );
  }

  /// 舉報別人的貼文
  void _onTapReportPostButton(num feedId, ReportListInfo reportListInfo, String reportText, num userId,)  {
    LoadingAnimation.showOverlayLoading(context);
    viewModel.reportActivityPost(
      feedId: feedId,
      reportListInfo: reportListInfo,
      reportText: reportText,
      userId: userId,
      onConnectSuccess: (msg) {
        _showReportPostConfirmDialog();
        LoadingAnimation.cancelOverlayLoading();
      },
      onConnectFail: (msg) {
        if (context.mounted) {
          BaseViewModel.showToast(context, ResponseCode.map[msg]!);
        }
        LoadingAnimation.cancelOverlayLoading();
      },
    );
  }

  /// 刪除自己貼文
  void _onTapDeletePostButton(num feedsId)  {
    viewModel.deletePersonalActivityPost(
        feedsId: feedsId,
        onConnectSuccess: (msg) {
          BaseViewModel.popPage(context);
          BaseViewModel.popPage(context);
        },
        onConnectFail: (msg) {
          if (context.mounted) {
            BaseViewModel.showToast(context, ResponseCode.map[msg]!);
          }
        });
  }

  /// 點擊Donate 按鈕
  void _onTapDonateButton(){
    ///審核中不能執行Donate
    if(postInfo.status ==0){
      BaseViewModel.showToast(context, '动态审核中，无法使用此功能');
      return;
    }
    TouchFeedbackUtil.lightImpact();///震動效果
    final num freFeedId = postInfo.id ?? 0;
    viewModel.donateActivityPost(
      freFeedId: freFeedId,
      onConnectSuccess: (msg) {
        ///執行硬幣動畫
        _donatAnimationController.reset();
        _donatAnimationController.forward();
      },
      onConnectFail: (errMsg) {
        if (errMsg == ResponseCode.CODE_ACTIVITY_DONATE_NOT_ENOUGH_ERROR) {
          rechargeHandler();
        } else {
          BaseViewModel.showToast(context, ResponseCode.map[errMsg]!);
        }
      },
    );
  }

  /// 點擊 讚 按鈕
  void _onTapLikeButton(bool isAlreadyLike){
    if(postInfo.status ==0){
      BaseViewModel.showToast(context, '动态审核中，无法使用此功能');
      return;
    }
    if(_lastOnTapLikeButtonTime != null && isAlreadyLike == false){
      final DateTime currentDateTime = DateTime.now();
      Duration difference = currentDateTime.difference(_lastOnTapLikeButtonTime!);
      if(difference.inSeconds<30){
        BaseViewModel.showToast(context, '操作频繁，请30秒后再试');
        return;
      }
    }
    TouchFeedbackUtil.lightImpact();///震動效果
    if(isAlreadyLike){
      _lastOnTapLikeButtonTime = DateTime.now();
      viewModel.cancelLike(postId: postInfo.id!);
    }else{
      viewModel.addLike(postId: postInfo.id!);
    }
  }
  @override
  void initState() {
    super.initState();
    _donatAnimationController = AnimationController(vsync: this);
    _donatAnimationController.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        // custom code here
        print('結束！');
      }
    });
  }

  @override
  void dispose() {
    _donatAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _iconButtonList(),
        _settingButton()
      ],
    );
  }

  /// 互動按鈕列表（打賞/按讚/留言）
  Widget _iconButtonList() {
    return Row(
      children: [
        _donateAreaWidget(),
        _likeIconButton(),
        // _messageIconButton(),
      ],
    );
  }

  /// 互動按鈕列表 - 打賞
  Widget _donateAreaWidget() {
    return Visibility(
      visible: viewModel.isEnabledDonate(postInfo),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          _donateButton(),
          Positioned(
            bottom: 18.h,
            child: IgnorePointer(
              child: _donateCoinWidget(),
            ),
          )
        ],
      ),
    );
  }

  /// 互動按鈕列表 - 打賞 - 按鈕
  Widget _donateButton(){
    return CommonButton(
      btnType: CommonButtonType.custom,
      cornerType: CommonButtonCornerType.custom,
      isEnabledTapLimitTimer: true,
      clickLimitTime: 1,
      customWidget: ImgUtil.buildFromImgPath(_appImageTheme.iconActivityPostDonate, width:60.w,height: 28.h, fit: BoxFit.contain),
      onTap: () => _onTapDonateButton(),
    );
  }

  /// 互動按鈕列表 - 打賞 - 硬幣（動畫）
  Widget _donateCoinWidget(){
    return Lottie.asset(
      'assets/json/activity_post_cost_coin.json',
      width: 50.w,
      height: 50.w,
      fit: BoxFit.fill,
      controller: _donatAnimationController,
      onLoaded: (composition) {
        print("onLoaded");
        setState(() {
          _donatAnimationController.duration = composition.duration;
        });
      },
    );
  }

  /// 互動按鈕列表 - 按讚
  Widget _likeIconButton(){
    final num likesCount = postInfo.likesCount ?? 0;
    final bool isAlreadyLike = viewModel.isAlreadyLike(likeList: likeList, id: postInfo.id ?? 0);
    final String likeImg = isAlreadyLike ? _appImageTheme.iconActivityPostAlreadyLike : _appImageTheme.iconActivityPostLike;
    return Container(
      // margin: EdgeInsets.only(left: 8.w),
      child: _iconButton(
        onTap: () => _onTapLikeButton(isAlreadyLike),
        icon: ImgUtil.buildFromImgPath(likeImg, size: 20.w),
        data: '$likesCount', dataColor: AppColors.textBlack
    ),);
  }

  /// 互動按鈕列表 - 留言
  Widget _messageIconButton(){
    final num replyCount = postInfo.replyCount ?? 0;
    return Container(
      // margin: EdgeInsets.only(left: 8.w),
      child: _iconButton(
          onTap: () =>widget.onTapMessageButton(),
          icon: ImgUtil.buildFromImgPath(_appImageTheme.iconActivityPostMessage, size: 20.w),
          data: '$replyCount', dataColor: AppColors.textBlack
      ),
    );
  }

  /// 互動icon按鈕
  Widget _iconButton({required Widget icon, required dynamic data, required Color dataColor, required Function() onTap}) {
    return CommonButton(
      btnType: CommonButtonType.custom,
      cornerType: CommonButtonCornerType.custom,
      isEnabledTapLimitTimer: true,
      clickLimitTime: 1,
      customWidget: Padding(
        padding: EdgeInsets.only(left: 8.w, top: 4.h, bottom: 4.h),
        child: Row(
          children: [
            icon,
            Text('$data', style:_appTextTheme.activityPostAmountTextStyle),
          ],
        ),
      ),
      onTap: () => onTap(),
    );
  }

  /// 設定按鈕
  Widget _settingButton() {
    return InkWell(
      onTap: () {
        if(postInfo.status ==0){
          BaseViewModel.showToast(context, '动态审核中，无法使用此功能');
          return;
        }
        _showMoreBottomDialog();
      },
      child: ImgUtil.buildFromImgPath(_appImageTheme.iconActivityMore, size: 24.w),
    );
  }
}