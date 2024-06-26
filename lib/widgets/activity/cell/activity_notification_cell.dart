import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_search_info_req.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/screens/activity/activity_post_detail.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/database/model/activity_message_model.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/avatar_util.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/activity/cell/activity_video_player.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/media_thumbnail.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class ActivityNotificationCell extends ConsumerStatefulWidget {

  final ActivityMessageModel activityMessageModel;

  const ActivityNotificationCell({
    super.key,
    required this.activityMessageModel
  });

  @override
  ConsumerState<ActivityNotificationCell> createState() => _ActivityNotificationCellState();
}

class _ActivityNotificationCellState extends ConsumerState<ActivityNotificationCell> {


  ActivityMessageModel get activityMessageModel => widget.activityMessageModel;
  late AppTheme _theme;
  late AppTextTheme _appTextTheme;
  // 取得單篇貼文資訊
  Future<void> getSingleActivityPost(num feedsId) async {
    String resultCodeCheck = '';
    WsActivitySearchInfoType type = WsActivitySearchInfoType.postInfo;
    String typeString = WsActivitySearchInfoType.values.indexOf(type).toString();
    final WsActivitySearchInfoReq reqBody = WsActivitySearchInfoReq.create(type: typeString, condition: '0', id: feedsId);
    final WsActivitySearchInfoRes res = await ref.read(activityWsProvider).wsActivitySearchInfo(
      reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      res.type = type;
      _refreshActivityAllLikePostIdList(res.likeList ?? []);
      await ref.read(userUtilProvider.notifier).loadActivityInfoOthers(res);
      List<ActivityPostInfo?> list = ref.read(userInfoProvider).activitySearchInfoOthers?.list ?? [];
      if (context.mounted) {
        if (list.isNotEmpty) {
          BaseViewModel.pushPage(context, ActivityPostDetail(postInfo: list.first!));
        } else {
          BaseViewModel.showToast(context, '查无贴文');
        }
      }
    }
  }
  /// 更新至 全部已按讚動態貼文ID清單
  Future<void> _refreshActivityAllLikePostIdList(List<dynamic> likeList) async{
    List<dynamic> allLikeList = await ref.read(userInfoProvider).activityAllLikePostIdList?? [];
    Set<dynamic> mergedSet = {};
    mergedSet.addAll(allLikeList);
    mergedSet.addAll(likeList);
    List<dynamic> mergedList = mergedSet.toList();
    ref.read(userUtilProvider.notifier).loadActivityAllLikePostIdList(mergedList);
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appTextTheme = _theme.getAppTextTheme;
    return InkWell(
      onTap: () {
        num feedsId = activityMessageModel.feedsId ?? 0;
        getSingleActivityPost(feedsId);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(flex:1,child: _leadingWidget()),
            Flexible(flex:8,child: _contentWidget()),
            Flexible(flex:2,child: _endingWidget()),
          ],
        ),
      ),
    );
  }

  Widget _leadingWidget(){

    String fromUserAvatar = activityMessageModel.fromUserAvatar ?? '';
    num fromUserGender = activityMessageModel.fromUserGender ?? 0;
    // num fromUserGender = ref.read(userInfoProvider).memberInfo?.gender == 0 ? 1 : 0;


    return fromUserAvatar.isEmpty
      ? AvatarUtil.defaultAvatar(fromUserGender, size: 32.h, radius: 8)
      : AvatarUtil.userAvatar(HttpSetting.baseImagePath + fromUserAvatar, size: 32.h, radius: 8);

  }
  Widget _contentWidget(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _titleLabel(),
          SizedBox(width: 4.w),
          _contentLabel(),
        ],
      ),
    );
  }

  Widget _titleLabel() {

    String fromUserNickName = activityMessageModel.fromUserNickName ?? '';


    return Text(
      "$fromUserNickName",
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style:  _appTextTheme.labelPrimarySubtitleTextStyle,
    );
  }

  Widget _contentLabel(){
    // 1:留言 2:回復 3:按讚 4:打賞
    num notifyType = activityMessageModel.notifyType ?? 0;

    String content = '';

    switch (notifyType) {
      case 1:
        content = '在你的动态留言';
        break;
      case 2:
        content = '回复了你的留言';
        break;
      case 3:
        content = '说你的动态赞';
        break;
      case 4:
        content = '打赏了你的动态';
        break;
      default:
        break;
    }

    return Text(
      "$content",
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: _appTextTheme.labelPrimaryContentTextStyle,
    );
  }


  Widget _endingWidget() {
    num postType = activityMessageModel.postType ?? 0;
    String contentUrl = activityMessageModel.contentUrl ?? '';
    List<String> contentUrls = contentUrl.split(',').toList();
    String firstContentUrl = contentUrls.first ?? '';


    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: postType == 0 ? _buildImgThumbnail(firstContentUrl) : _buildVideoThumbnail(firstContentUrl)
    );
  }

  Widget _buildImgThumbnail(String url) {
    return CachedNetworkImageUtil.load(HttpSetting.baseImagePath + url, size: 48.w);
  }

  Widget _buildVideoThumbnail(String url) {
    return MediaThumbnail(
      videoUrl: HttpSetting.baseImagePath + url,
      borderRadius: 6,
      width: 48.w,
      height: 48.w,
    );
  }
}
