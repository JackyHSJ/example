

import 'dart:io';
import 'package:frechat/models/req/add_activity_post_req.dart';
import 'package:frechat/models/res/add_activity_post_res.dart';
import 'package:frechat/models/user_info_model.dart';
import 'package:frechat/models/ws_req/activity/ws_activity_hot_topic_list_req.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_hot_topic_list_res.dart';
import 'package:frechat/models/ws_res/activity/ws_activity_search_info_res.dart';
import 'package:frechat/screens/image_links_viewer.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/video_compress_util.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/util/image_picker_util.dart';
import 'package:frechat/system/util/permission_util.dart';
import 'package:frechat/widgets/theme/app_theme.dart';
import 'package:video_compress/video_compress.dart';
import 'package:path/path.dart' as p;


class ActivityAddPostViewModel {

  ViewChange setState;
  WidgetRef ref;
  BuildContext context;

  ActivityAddPostViewModel({
    required this.setState,
    required this.ref,
    required this.context,
  });

  // 內容：必填
  // 照片/影片：必填
  // 話題標籤：選填

  int desCurrentLength = 0;
  List<File> selectImgList = []; // 已選取圖片
  int postType = 0; // 0: 圖片, 1:影片
  List<HotTopicListInfo?> topicList = []; // 話題標籤列表
  HotTopicListInfo? selectedTopic; // 已選取的

  late TextEditingController contentTextController;
  final int desMaxLength = 300;
  final int pictureMax = 5;
  final String tipMsg = '''
・图片上传格为：.jpg、.jpeg、.png、.bmp、.gif
・图片档案大小限制：单张5MB内
・图片上传上限：5张
・视频上传格式为：.mp4、.mov
・视频档案限制：长度一分钟内，分辨率720P，
大小20MB内
・视频上传上限：1则''';

  bool canSend = false;
  List<String> validImgExtensions = ['.jpg', '.png', '.jpeg', '.bmp', '.gif'];
  List<String> validMediaExtensions = ['.mov', '.mp4'];




  // init
  init() {
    contentTextController = TextEditingController();
    _getActivityTopicList();
  }

  // dispose
  dispose() {
    contentTextController.dispose();
  }

  // 拍照
  takeImg({
    required Function() onShowFrequentlyDialog
  }) async {
    //防止連續登入問題 (裁圖/照相功能會造成斷線)
    if (ref.read(commApiProvider).isLegalForNextLogin()) {
      final XFile? imgXFile = await ImagePickerUtil.takePicFrontCamera();
      if (imgXFile == null) return;
      selectImgList.add(File(imgXFile.path));
      canSendHandler();
      setState(() {});
    } else {
      await onShowFrequentlyDialog();
    }
  }

  void canSendHandler() {
    if (desCurrentLength > 0 && selectImgList.isNotEmpty) {
      canSend = true;
    } else {
      canSend = false;
    }
  }

  // 選擇照片
  selectImg() async {
    final List<XFile> xFileList = await ImagePickerUtil.selectMultiImg(selectMax: 5);
    List<File> selectedList = xFileList.map((xFile) => File(xFile.path)).toList();
    bool extensionResult = imageExtensionCheck(selectedList);
    bool sizeResult = await imageSizeCheck(selectedList);

    if (!extensionResult || !sizeResult) {
      showImageErrorDialog();
      return;
    }

    // 图片最多上传5张
    if (selectedList.length + selectImgList.length > 5) {
      if (context.mounted) BaseViewModel.showToast(context, '图片最多上传5张');
      return;
    }

    selectImgList.addAll(selectedList);
    postType = 0;
    canSendHandler();
    setState((){});
  }

  // 移除照片
  cancelImg(int index) {
    selectImgList.removeAt(index);
    canSendHandler();
    setState((){});
  }

  // 選擇影片
  selectVideo() async {
    final XFile? xFile = await ImagePickerUtil.selectVideo();
    if (xFile == null) return;

    // media info
    MediaInfo info = await VideoCompressUtil.getMediaInfo(xFile.path);
    num mediaDuration = VideoCompressUtil.getMediaDuration(info);
    num mediaFileSize = VideoCompressUtil.getMediaFileSize(info);

    // 時間要在 60 秒以內 & size 小於 20 MB
    if (mediaDuration > 60 || mediaFileSize > 20) {
      showVideoErrorDialog();
      return;
    }

    // 正常流程
    selectImgList.add(File(xFile.path));
    postType = 1;
    canSendHandler();
    setState((){});

  }

  // 檢查 image 檔案格式
  bool imageExtensionCheck(List<File> files) {
    List<bool> extensionList = files.map((item) {
      String fileExtension = p.extension(item.path);
      if (validImgExtensions.contains(fileExtension)) {
        return true;
      }
      return false;
    }).toList();
    return extensionList.contains(false) ? false : true;
  }

  Future<bool> imageSizeCheck(List<File> files) async {
    List<num> imgSizeList = [];
    for (var file in files) {
      num bytes = await file.length();
      num mb = bytes / 1048576;
      imgSizeList.add(mb);
    }
    return imgSizeList.any((item) => item > 5) ? false : true;
  }

  void showVideoErrorDialog() {
    AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);

    CommDialog(context).build(
      theme: theme,
      title: '',
      contentDes: '可上传图片格式为：.mp4、.mov，并且档案上限为20MB内、720P、时长一分钟内请重新上传',
      rightBtnTitle: '确认',
      rightAction: () => BaseViewModel.popPage(context)
    );
  }

  void showImageErrorDialog() {
    AppTheme theme = ref.read(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    CommDialog(context).build(
        theme: theme,
        title: '',
        contentDes: '可上传图片格式为：.jpg、.jpeg、.png、.bmp、.gif，并且档案上限为单张5MB内请重新上传',
        rightBtnTitle: '确认',
        rightAction: () => BaseViewModel.popPage(context)
    );
  }

  // 瀏覽圖片
  showBrowserImg(BuildContext context, {required int index}) {
    List<ImageProvider> imageProviders = selectImgList.map((file) => FileImage(file)).toList();
    ImageLinksViewer.show(context, ImageLinksViewerArgs(
      imageLinks: imageProviders,
      initialPage: index,
      transparentBackground: true
    ));
  }

  /// 动态類型 0: 图片动态 1:影片动态
  Future<void> addPost(BuildContext context) async {

    String content = contentTextController.text;

    if (content.isEmpty || selectImgList.isEmpty) {
      // BaseViewModel.showToast(context, '参数有缺');
      return;
    }

    LoadingAnimation.showOverlayLoading(context);
    String resultCodeCheck = '';
    final String token = ref.read(userInfoProvider).commToken ?? '';
    final AddActivityPostReq reqBody = AddActivityPostReq.create(
      tId: token,
      files: selectImgList,
      type: postType.toString(),
      content: content,
      userLocation: null,
      topicId: selectedTopic?.topicId,
    );

    final UserInfoModel userInfo = ref.read(userInfoProvider);
    num blockType = userInfo.buttonConfigList?.blockType ?? 0;
    // 判斷審核中，不打後端，前端顯示審核中
    if (blockType == 1) {
      await Future.delayed(const Duration(milliseconds: 1500));
      _addUserReviewActivityPostInfoList();
      _recordPostTime();
      if (context.mounted) {
        BaseViewModel.popPage(context);
        BaseViewModel.popPage(context);
      }
      LoadingAnimation.cancelOverlayLoading();
      return;
    }

    final AddActivityPostRes? res = await ref.read(commApiProvider).addActivityPost(reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      _addUserReviewActivityPostInfoList();
      _recordPostTime();
      if (context.mounted) {
        BaseViewModel.popPage(context);
        BaseViewModel.popPage(context);
      }
    } else {
      if (context.mounted) BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
    }
    LoadingAnimation.cancelOverlayLoading();
  }

  // 話題標籤列表
  Future<void> _getActivityTopicList() async {
    String resultCodeCheck = '';

    final WsActivityHotTopicListReq reqBody = WsActivityHotTopicListReq.create();
    final WsActivityHotTopicListRes res = await ref.read(activityWsProvider).wsActivityHotTopicList(reqBody,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      topicList = res.list ?? [];
      setState(() {});
    } else {
      if (context.mounted) BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
    }
  }


  /// 暫存使用者新發的貼文
  _addUserReviewActivityPostInfoList() {
    ActivityPostInfo postInfo =ActivityPostInfo();
    postInfo.gender =  ref.read(userInfoProvider).memberInfo?.gender;
    postInfo.userLocation = ref.read(userInfoProvider).memberInfo?.location ?? '';
    postInfo.userName =  ref.read(userInfoProvider).memberInfo?.userName;
    postInfo.nickName = ref.read(userInfoProvider).memberInfo?.nickName ?? '';
    postInfo.age = ref.read(userInfoProvider).memberInfo?.age ?? 0;
    postInfo.avatar = ref.read(userInfoProvider).memberInfo?.avatarPath ?? '';
    postInfo.topicId = selectedTopic?.topicId;
    postInfo.type = postType;
    postInfo.content = contentTextController.text;
    postInfo.likesCount = 0;
    postInfo.replyCount = 0;
    postInfo.id = 0;
    postInfo.status = 0;
    postInfo.createTime = DateTime.now().millisecondsSinceEpoch;
    final urlPathList = selectImgList.map((img) => img.path).toList();
    String urlListString  = urlPathList.join(',');
    postInfo.contentLocalUrl = urlListString;
    List<ActivityPostInfo> globalActivityPostInfoList = GlobalData.cacheUserPostActivityPostInfoList??[];
    globalActivityPostInfoList.insert(0,postInfo);
    GlobalData.cacheUserPostActivityPostInfoList = globalActivityPostInfoList;
  }

  // 紀錄貼文時間
  void _recordPostTime() {
    int postTime = DateTime.now().millisecondsSinceEpoch;
    FcPrefs.setLastPostTime(postTime);
  }
}