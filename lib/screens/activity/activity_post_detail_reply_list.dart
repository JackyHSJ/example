


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_reply_info_res.dart';
import 'package:frechat/models/ws_res/report/ws_report_search_type_res.dart';
import 'package:frechat/screens/activity/activity_post_detail_reply_list_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/widgets/activity/activity_post_util.dart';
import 'package:frechat/system/assets_path/assets_images_path.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:frechat/system/util/convert_util.dart';
import 'package:frechat/widgets/activity/activity_report_dialog.dart';
import 'package:frechat/widgets/shared/bottom_sheet/common_bottom_sheet.dart';
import 'package:frechat/widgets/shared/dialog/base_dialog.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/icon_tag.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

typedef ClickCallback = void Function(num value);
typedef TagUserNameCallback = void Function(String tagUserName);


class ActivityPostDetailReplyList extends ConsumerStatefulWidget {

  final ActivityReplyInfo activityReplyInfo;
  final RichTextController richTextController;
  final FocusNode focusNode;
  final ClickCallback onClick;
  final TagUserNameCallback tagNameCheck;
  final ActivityPostInfo postInfo;

  const ActivityPostDetailReplyList(  {
    super.key,
    required this.activityReplyInfo,
    required this.focusNode,
    required this.richTextController,
    required this.onClick,
    required this.tagNameCheck,
    required this.postInfo
  });

  @override
  ConsumerState<ActivityPostDetailReplyList> createState() => _ActivityPostDetailSecondReplyListState();
}

class _ActivityPostDetailSecondReplyListState extends ConsumerState<ActivityPostDetailReplyList> {

  late ActivityPostDetailReplyListViewModel viewModel;
  String personalUserName = ''; // 個人的 userName

  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppTextTheme _appTextTheme;
  late AppImageTheme _appImageTheme;

  @override
  void initState() {
    viewModel = ActivityPostDetailReplyListViewModel(setState: setState, ref: ref, context: context);
    viewModel.replyCount = widget.activityReplyInfo.replyCount ?? 0;
    viewModel.postInfo = widget.postInfo;
    personalUserName = ref.read(userInfoProvider).memberInfo?.userName ?? '';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appTextTheme = _theme.getAppTextTheme;
    _appImageTheme = _theme.getAppImageTheme;
    if (viewModel.mainReplyDeleted) {
      return const SizedBox();
    }

    return Container(
      padding: EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w, bottom: 6.h),
      color: _appColorTheme.baseBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 第一層留言
          _buildMainReplyCell(),

          // 第二層留言
          _buildSubReplyList(),
        ],
      ),
    );
  }

  // 第一層留言
  Widget _buildMainReplyCell() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReplyUserInfo(),
        _buildReplyContent(),
        SizedBox(width: double.infinity, height: 8.h),
        _buildSingleReplyAndSeeMore(),
      ],
    );
  }

  // replyUserInfo
  Widget _buildReplyUserInfo() {
    final String userName = widget.activityReplyInfo?.userName ?? '';
    final String nickName = widget.activityReplyInfo?.nickName ?? '';
    final String displayName = ConvertUtil.displayName(userName, nickName, '');
    final String createTime  = viewModel.getPostTime(widget.activityReplyInfo.createTime?.toInt()??0);
    final bool isRealPersonAuth  = widget.activityReplyInfo?.realPersonAuth == 1 ? true : false;
    final String avatar = widget.activityReplyInfo?.avatar ?? '';
    final num gender = widget.activityReplyInfo?.gender ?? 0;
    final num age = widget.activityReplyInfo?.age ?? 0;
    final num id = widget.activityReplyInfo?.id ?? 0;


    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildReplyAvatar(avatar, gender, 34.w),
        SizedBox(width: 8.w),
        userNameAndTimeOrReply(displayName, createTime, userName, false, isRealPersonAuth, gender, age, id),
        const Expanded(child: SizedBox()),
        _buildReportOrDeleteBtn(widget.activityReplyInfo, 0),
      ],
    );
  }

  // replyAvatar
  Widget _buildReplyAvatar(String avatarPath, num gender, double avatarSize) {
    return avatarPath.isNotEmpty
        ? AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatarPath, size: avatarSize, radius: 8)
        : AvatarUtil.defaultAvatar(gender, size: avatarSize, radius: 8);
  }

  // userName, createTime, gender&age
  Widget userNameAndTimeOrReply(
    String name,
    String createTime,
    String userName,
    bool showReply,
    bool isRealPersonAuth,
    num gender,
    num age,
    num id
  ) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('${ConvertUtil.truncateString('$name', 7)}',style: _appTextTheme.activityPostReplyTitleTextStyle),
            SizedBox(width: 4.w),
            IconTag.genderAge(gender: gender, age: age),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(createTime,style: _appTextTheme.activityPostReplyDateTextStyle),

            SizedBox(width: 12.w),
            (showReply) ? _buildTagReply(name, userName) : const SizedBox()
          ],
        ),
      ],
    );
  }


  // Tag Reply
  Widget _buildTagReply(String name, String userName) {

    // if (userName == personalUserName) return const SizedBox();

    return InkWell(
      child: Text('回复',style: _appTextTheme.activityPostReplyActionTextStyle),
      onTap: () {

        // tag 第二層的人
        FocusScope.of(context).requestFocus(widget.focusNode);
        if (userName != personalUserName) {
          widget.tagNameCheck(userName);
          widget.richTextController!.text = '@$name ';
        }
        num replyId = widget.activityReplyInfo.id ?? 0;
        widget.onClick(replyId);

        setState(() {});
      },
    );
  }

  // 回覆内容
  Widget _buildReplyContent() {
    String content = widget.activityReplyInfo.content ?? '';
    return Padding(
      padding: EdgeInsets.only(top: 2.h, left: 42.w),
      child: Text(content,style: _appTextTheme.activityPostReplyContentTextStyle),
      // child: contentText('content: ${content}, id: ${id}'),
    );
  }

  // 單則回覆和查看更多
  Widget _buildSingleReplyAndSeeMore() {
    num replyCount = viewModel.replyCount;
    return Container(
      padding: EdgeInsets.only(left: 42.w),
      child: Row(
        children: [
          InkWell(
            child: Text('回复',style: _appTextTheme.activityPostReplyActionTextStyle),
            onTap: () {
              // 按下回复指我在這留言下留言
              final num replyId = widget.activityReplyInfo.id ?? 0;
              // viewModel.replyType = 1;
              widget.onClick(replyId);
              FocusScope.of(context).requestFocus(widget.focusNode);
            },
          ),
          ActivityPostUtil.verticalDivider(1, 14, leftPadding: 8, rightPadding: 8),
          (replyCount > 0)
              ? _buildReplyMore()
              : Container(),
        ],
      ),
    );
  }

  Widget _buildReplyMore() {
    num replyCount = viewModel.replyCount;

    if (viewModel.isSubReplyListOpen) {
      return SizedBox();
    }

    return InkWell(
      onTap: () {
        if (viewModel.isSubReplyListOpen) return;
        setState(() {
          viewModel.isSubReplyListLoading = true;
          final num id = widget.activityReplyInfo.id ?? 0;
          viewModel.getSubReplyList(id);
        });
      },
      child: Text('查看其他 $replyCount 则回复',style: _appTextTheme.activityPostReplyActionTextStyle),
    );
  }

  // 隱藏更多
  Widget singleReplyAndHide() {
    num replayCount = viewModel.replyCount;
    return Padding(
      padding: EdgeInsets.only(left: 42.w),
      child: InkWell(
        child: Text('隐藏其他 ${replayCount} 则回复',style: _appTextTheme.activityPostReplyActionTextStyle),
        onTap: () {
          setState(() {
            viewModel.isSubReplyListOpen = false;
          });
        },
      ),
    );
  }




  // 第二層

  Widget _buildSubReplyList() {

    if (viewModel.isSubReplyListLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
            width: 12,
            height: 12,
            child: FittedBox(
              child: CircularProgressIndicator(),
            )
          ),
        )
      );
    }

    if (viewModel.isSubReplyListOpen) {
      return secondReply();
    } else {
      return const SizedBox();
    }
  }

  // 第二層回覆 List
  Widget secondReply(){
    return ListView.builder(
        padding: EdgeInsets.only(top: 6.h, left: 40.w, bottom: 6.h),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: viewModel.subReplyList.length,
        itemBuilder: (context, index) {
          final ActivityReplyInfo activityReplyInfoLast = viewModel.subReplyList.last;
          final bool isLast = viewModel.subReplyList[index] == activityReplyInfoLast;
          return secondReplyListItem(viewModel.subReplyList[index],isLast);
        }
    );
  }

  // 第二層回覆組件
  Widget secondReplyListItem(ActivityReplyInfo activityReplyInfo,bool showHide){
    final String userName = activityReplyInfo.userName ?? '';
    final String nickName = activityReplyInfo.nickName ?? '';
    final String displayName = ConvertUtil.displayName(userName, nickName, '');
    final String createTime  = ActivityPostUtil.formatTimestampToDateTime(activityReplyInfo.createTime!.toInt());
    final bool isRealPersonAuth  = activityReplyInfo.realPersonAuth == 1 ? true : false;
    final String avatar = activityReplyInfo.avatar ?? '';
    final num gender = activityReplyInfo.gender ?? 0;
    final num age = activityReplyInfo.age ?? 0;
    final String content = activityReplyInfo.content ?? '';
    // final num id = activityReplyInfo.id ?? 0;
    final num userId = activityReplyInfo.userId ?? 0;
    final num id = activityReplyInfo.id ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ActivityPostUtil.verticalDivider(2, 24, rightPadding: 8),
            _buildReplyAvatar(avatar, gender, 24.w),
            SizedBox(width: 8.w),
            userNameAndTimeOrReply(displayName, createTime, userName, true, isRealPersonAuth, gender, age, id),
            const Expanded(child: SizedBox()),
            _buildReportOrDeleteBtn(activityReplyInfo, 1),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 42.w),
              child: Text(content,style: _appTextTheme.activityPostReplyContentTextStyle),
            ),
            SizedBox(width: double.infinity, height: 12.h),
            (showHide) ? singleReplyAndHide() : Container()
          ],
        )
      ],
    );
  }

  // 刪除或舉報按鈕
  Widget _buildReportOrDeleteBtn(ActivityReplyInfo activityReplyInfo, num type) {
    return InkWell(
      onTap: () {
        showBottomDialog(activityReplyInfo, type);
      },
      child: ImgUtil.buildFromImgPath(_appImageTheme.iconActivityMore,size: 24),
    );
  }

  // 選擇彈窗
  void showBottomDialog(ActivityReplyInfo activityReplyInfo, num type) {

    final String replyUserName = activityReplyInfo.userName ?? '';
    final num userId = activityReplyInfo.userId ?? 0;
    final num replyId = activityReplyInfo.id ?? 0;

    String title = '';
    title = replyUserName == personalUserName ? '刪除' : '举报';

    CommonBottomSheet.show(context,
      title: '针对此留言',
      actions: [
        CommonBottomSheetAction(
          title: title,
          titleStyle: const TextStyle(
            fontSize: 16,
            color: Color(0xFFFF3B30),
            fontWeight: FontWeight.w400
          ),
          onTap: () {
            BaseViewModel.popPage(context);
            if (title == '刪除') {
              deleteReplyDialog(replyId, userId, type); // 留言刪除
            } else {
              reportReplyDialog(replyId, userId); // 舉報
            }
          },
        ),
      ],
    );
  }

  // 刪除確認彈窗
  void deleteReplyDialog(num replyId, num userId, num type) {
    AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    CommDialog(context).build(
      theme: theme,
      title: '即将删除你的留言',
      contentDes: '删除后将不可回复',
      leftBtnTitle: '取消',
      rightBtnTitle: '确定删除',
      leftAction: () => BaseViewModel.popPage(context),
      rightAction: () {
        viewModel.deletePersonalReply(replyId, type);
      }
    );
  }

  // 舉報彈窗
  void reportReplyDialog(num replyId, num userId) {
    BaseDialog(context).showTransparentDialog(
      isDialogCancel: true,
      widget: ActivityReportDialog(
        title: "举报此留言",
        onTap: (ReportListInfo reportListInfo, String text) {
          viewModel.reportOthersReply(replyId, reportListInfo, text, userId);
        },
      ),
    );
  }


}
