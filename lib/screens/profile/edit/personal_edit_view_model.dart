import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/certification_model.dart';
import 'package:frechat/models/ws_req/member/ws_member_delete_album_photo_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_info_req.dart';
import 'package:frechat/models/ws_req/member/ws_member_move_album_photo_req.dart';
import 'package:frechat/models/ws_res/member/ws_member_delete_album_photo_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_info_res.dart';
import 'package:frechat/models/ws_res/member/ws_member_move_album_photo_res.dart';
import 'package:frechat/screens/profile/edit/audio/personal_edit_audio.dart';
import 'package:frechat/screens/profile/edit/intro/personal_edit_intro.dart';
import 'package:frechat/screens/profile/edit/tag/personal_edit_tag.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/image_picker_util.dart';
import 'package:frechat/system/util/permission_util.dart';
import 'package:frechat/widgets/loading_dialog/loading_widget.dart';
import 'package:frechat/widgets/profile/cell/personal_cell.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';

import '../../../models/profile/personal_cell_model.dart';
import '../../../models/req/account_modify_user_req.dart';
import '../../../models/ws_res/mission/ws_mission_search_status_res.dart';
import '../../../system/provider/user_info_provider.dart';
import '../../../system/providers.dart';
import '../../../system/repository/response_code.dart';
import '../../../widgets/strike_up_list/strike_up_list_extension.dart';
import 'nick_name/personal_edit_nick_name.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class EditImgModel {
  EditImgModel({
    required this.path,
    required this.type,
    this.albumsPathInfo,
  });
  String path;
  ImgType type;
  AlbumsPathInfo? albumsPathInfo;

  bool hasPath() {
    return path.isNotEmpty;
  }

  String getHeroTag() {
    return path;
  }

  ImageProvider? getImageProvider() {
    switch (type) {
      case ImgType.filePath:
        return FileImage(File(path));
      case ImgType.urlPath:
        return CachedNetworkImageProvider(path);
      default:
        return null;
    }
  }
}

class PersonalEditViewModel {
  PersonalEditViewModel({required this.ref, required this.setState});

  WidgetRef ref;
  ViewChange setState;

  String? selectNickName;
  List<EditImgModel> selectImgList = List.generate(6, (index) => EditImgModel(path: '', type: ImgType.none));
  File? selectAudio;
  int? selectAge;
  num? selectHeight;
  num? selectWeight;
  String? selectOccupation;
  String? selectAnnualIncome;
  String? selectEducation;
  int? selectMaritalStatus;
  String? selectSelfIntroduction;
  String? selectHomeTown;
  File? selectAvatar;
  List<String>? selectTag;
  double processPercent = 0;
  WsMissionSearchStatusRes? missions;
  bool isNewAvatar  = false;

  //是否被編輯過
  bool hasChanged = false;

  List<PersonalCellModel> cellList = [];

  init() async {
    /// 讀取member info 到 cell
    final WsMemberInfoRes? memberInfo = ref.read(userUtilProvider).memberInfo;
    await loadMission();
    await loadMemberToCell(memberInfo);
    processPercent = _getProgressPercent(memberInfo);
    PersonalEditTag.chooseList = memberInfo?.tag?.split(',') ?? [];

    setState(() {});
  }

  getMissionVal(int index) {

    num gender = ref.read(userInfoProvider).memberInfo?.gender ?? 0;
    num count = 0;

    if (gender == 0 && missions?.list?[index].status == '-1') {
      count = missions?.list?[index].points ?? 0;
    } else {
      count = missions?.list?[index].coins ?? 0;
    }

    if (gender == 1) {
      count = missions?.list?[index].coins ?? 0;
    }

    return count;
  }

  getMissionLabel(int no) {
    String label = '金币';
    return label;
  }

  loadMission() async {
    missions = await StrikeUpListExtension.getMissionInfo(ref);
    setState(() {});
  }

  loadMemberToCell(WsMemberInfoRes? memberInfo) async {
    if (memberInfo != null) {
      CertificationType nickNameCertificationType = CertificationModel.getType(authNum: memberInfo.nickNameAuth);
      if (memberInfo.nickName == null) {
        //沒東西? 先檢查是否未過審
        if (nickNameCertificationType == CertificationType.fail) {
          //使用 prefs 內的暫存資料
          String submittedNickName = await FcPrefs.getSubmittedNickName();
          cellList[0].des = memberInfo.userName;
          // if (submittedNickName.isNotEmpty) {
          //   cellList[0].des = submittedNickName;
          // } else {
          //   //沒辦法了，就顯示 id 吧
          //   cellList[0].des = memberInfo.userName;
          // }
        }else if(nickNameCertificationType == CertificationType.resend){
          String submittedNickName = await FcPrefs.getSubmittedNickName();
          if (submittedNickName.isNotEmpty) {
            cellList[0].des = submittedNickName;
          } else {
            //沒辦法了，就顯示 id 吧
            cellList[0].des = memberInfo.userName;
          }
        }else if(nickNameCertificationType == CertificationType.processing){
          String submittedNickName = await FcPrefs.getSubmittedNickName();
          if (submittedNickName.isNotEmpty) {
            cellList[0].des = submittedNickName;
          } else {
            //沒辦法了，就顯示 id 吧
            cellList[0].des = memberInfo.userName;
          }
        } else {
          //沒辦法了，就顯示 id 吧
          cellList[0].des = memberInfo.userName;
        }
      } else {
        cellList[0].des = memberInfo.nickName;
      }

      //NickName 送審狀況下不能被修改
      cellList[0].editable = (nickNameCertificationType != CertificationType.processing && nickNameCertificationType != CertificationType.resend);
      cellList[0].statusTag = CertificationModel.toTitle(authNum: memberInfo.nickNameAuth);
      // log('NickName editable: ${cellList[0].editable} | ${memberInfo.nickNameAuth} | $nickNameCertificationType');

      //相簿
      // cellList[1]
      _loadImgFromMemberInfo(memberInfo);
      //檢查是否所有的 AlbumsPathInfo 都是審核過, 只要有其中一張審核中，就不允許編輯
      if (memberInfo.albumsPath != null) {
        for (AlbumsPathInfo albumsPathInfo in memberInfo.albumsPath!) {
          CertificationType albumsPathInfoCertificationType = CertificationModel.getType(authNum: albumsPathInfo.status);
          if (albumsPathInfoCertificationType == CertificationType.processing || albumsPathInfoCertificationType == CertificationType.resend) {
            //發現一張正在審核，因此設為不允許編輯
            cellList[1].editable = false;
            break;
          }
        }
      }

      cellList[2].des = (memberInfo.audioPath == null) ? null : basename(memberInfo.audioPath!);
      //audio 送審狀況下不能被修改
      CertificationType audioCertificationType = CertificationModel.getType(authNum: memberInfo.audioAuth);
      cellList[2].editable = (audioCertificationType != CertificationType.processing && audioCertificationType != CertificationType.resend);
      // log('Audio editable: ${cellList[2].editable} | ${memberInfo.audioAuth} | $audioCertificationType');

      cellList[3].des = '${memberInfo.age}岁';
      cellList[4].des = memberInfo.hometown;
      // cellList[5].des = memberInfo.location;
      cellList[5].des = (memberInfo.height == null) ? null : '${memberInfo.height?.toInt() ?? 0}cm';
      cellList[6].des = (memberInfo.weight == null) ? null : '${memberInfo.weight?.toInt() ?? 0}kg';
      cellList[7].des = memberInfo.occupation;
      cellList[8].des = (memberInfo.annualIncome == null) ? null : memberInfo.annualIncome;
      cellList[9].des = memberInfo.education;
      cellList[10].des = _getmaritalStatus(memberInfo.maritalStatus);
      cellList[11].des = (memberInfo.selfIntroduction == null) ? null : '';
      // cellList[12].hint = (memberInfo.selfIntroduction == null) ? '完善自我介绍+20金币' : null;
      cellList[11].hint = (memberInfo.selfIntroduction == null) ? '完善自我介绍 + ${getMissionVal(3)} ${getMissionLabel(3)}' : null;

      cellList[11].remark = (memberInfo.selfIntroduction == null) ? ['添加自我介绍更容易得到别人的关注哦'] : [memberInfo.selfIntroduction!];
      final List<String> tagList = memberInfo.tag?.split(',') ?? [];
      cellList[12].remark = (memberInfo.tag == null) ? ['我的个性标签'] : tagList;
      cellList[12].des = (memberInfo.tag == null) ? null : '';
      setState((){});
    }
  }

  _loadImgFromMemberInfo(WsMemberInfoRes? memberInfo) {
    final List<AlbumsPathInfo> albumsPathInfoList = memberInfo?.albumsPath ?? [];
    selectImgList.removeWhere((item) => item.path == '');
    for (var albumsPathInfo in albumsPathInfoList) {
      selectImgList.add(EditImgModel(albumsPathInfo: albumsPathInfo, path: HttpSetting.baseImagePath + albumsPathInfo.filePath!, type: ImgType.urlPath));
    }

    // 檢查選取的圖片數量是否少於6張，如果是，添加空的XFile對象直到达到6張
    while (selectImgList.length < 6) {
      selectImgList.add(EditImgModel(path: '', type: ImgType.none));
    }

    setState(() {});
  }

  double _getProgressPercent(WsMemberInfoRes? memberInfo) {
    double total = 9;
    double haveDataCount = 0;

    // 資料完善度：顯示目前資料完善百分比。
    // 年齡、家鄉、身高、體重、職業、年收入、學歷、婚姻狀態、我的標籤共 9 項。

    // if (memberInfo?.avatarPath != null) haveDataCount++;
    // if (memberInfo?.nickName != null) haveDataCount++;
    if (memberInfo?.age != null) haveDataCount++;
    // if (memberInfo?.albumsPath != null) haveDataCount++;
    // if (memberInfo?.audio != null) haveDataCount++;
    if (memberInfo?.hometown != null) haveDataCount++;
    if (memberInfo?.height != null) haveDataCount++;
    if (memberInfo?.weight != null) haveDataCount++;
    if (memberInfo?.occupation != null) haveDataCount++;
    if (memberInfo?.annualIncome != null) haveDataCount++;
    if (memberInfo?.education != null) haveDataCount++;
    if (memberInfo?.maritalStatus != null) haveDataCount++;
    // if (memberInfo?.selfIntroduction != null) haveDataCount++;
    if (memberInfo?.tag != null) haveDataCount++;

    return haveDataCount / total;
  }

  String? _getmaritalStatus(num? status) {
    switch (status) {
      case 0:
        return '單身';
      case 1:
        return '已婚';
      case 2:
        return '尋愛中';
      case 3:
        return '有伴侶';
      case 4:
        return '離異';
      default:
        return null;
    }
  }

  editMemberInfo({required Function(String) onConnectFail, required Function(String) onConnectSuccess}) async {
    String? resultCodeCheck;
    final String? commToken = ref.read(userInfoProvider).commToken;

    List<File>? albumImgs = selectImgList
        .map((img) => (img.path.isNotEmpty && img.type == ImgType.filePath) ? File(img.path) : null)
        .where((file) => file != null)
        .cast<File>()
        .toList();

    // 標籤如果是空的給字串 null，給後端去判斷
    if(selectTag !=null){
      if (selectTag!.isEmpty) selectTag?.add('null');
    }

    final MemberModifyUserReq req = MemberModifyUserReq.create(
        tId: commToken ?? 'emptyToken',
        nickName: selectNickName,
        albumImgs: albumImgs,
        // hometown: 'China',
        occupation: selectOccupation,
        annualIncome: selectAnnualIncome,
        education: selectEducation,
        age: selectAge,
        maritalStatus: selectMaritalStatus, // 婚姻狀況 0:單身 1:已婚
        weight: selectWeight,
        height: selectHeight,
        selfIntroduction: selectSelfIntroduction,
        hometown: selectHomeTown,
        avatarImg: selectAvatar,
        audio: selectAudio,
        tag: selectTag
    );

    final res = await ref.read(commApiProvider).memberModifyUser(req,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => onConnectFail(errMsg)
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      
      //特殊: selectNickName 如果有選鑿，則記下至 prefs 來作為顯示依據。
      //未過審時， 將會嘗試讀這個 prefs 出來顯示
      if (selectNickName != null) {
        String nickName = ref.read(userInfoProvider).memberInfo?.nickName ?? '';
        await FcPrefs.setSubmittedNickName(selectNickName!);
        await FcPrefs.setKeepNickNameInReview(nickName);
      }
      if(selectAvatar!=null){
        XFile? xFile = await convertFileToXFile(selectAvatar!);
        ImagePickerUtil.saveImageToLocal(xFile: xFile!, type: SaveImagType.avatar,fileName: 'avatar_${ref.read(userInfoProvider).userName!}.png');
      }

      if(selectAudio != null){
        copyAudioFile(selectAudio!);
      }

      onConnectSuccess(resultCodeCheck!);
    }
  }

  ///复制送审的录音档到app内
  Future<void> copyAudioFile(File oldFile) async {
    PermissionUtil.checkAndRequestGalleryPermission();
    final directory = await getApplicationDocumentsDirectory();
    String targetPath = path.join(directory.path, 'audio');
    final targetDir = Directory(targetPath);
    if (!await targetDir.exists()) await targetDir.create();
    oldFile.copy('${targetDir.path}/audio_${ref.read(userInfoProvider).userName!}.aac').then((File newFile) {
      print('File copied successfully to: ${newFile.path}');
    }).catchError((e) {
      print('Error occurred while copying the file: $e');
    });
  }

  Future<XFile?> convertFileToXFile(File file) async {
    if (file.existsSync()) {
      // 获取文件的路径
      String filePath = file.path;

      // 使用XFile构造函数将File对象转换为XFile对象
      XFile xFile = XFile(filePath);

      return xFile;
    } else {
      print('文件不存在');
      return null;
    }
  }

  Future<void> selectMultiImg() async {
    final List<XFile> select = await ImagePickerUtil.selectMultiImg();
    print('123123 select: ${select.first.name}');
    selectImgList.removeWhere((item) => item.path == '');
    for (var img in select) {
      if (selectImgList.length > 5) {
        continue;
      }
      selectImgList.add(EditImgModel(path: img.path, type: ImgType.filePath));
    }

    // 檢查選取的圖片數量是否少於6張，如果是，添加空的XFile對象直到达到6張
    while (selectImgList.length < 6) {
      selectImgList.add(EditImgModel(path: '', type: ImgType.none));
    }

    setState(() {});
  }

  bool resetFileImage(int index) {
    if (index >= 0 && index < selectImgList.length) {
      //防蠢
      if (selectImgList[index].type == ImgType.filePath) {
        //移除掉此格並且補一個空的在最後
        selectImgList.removeAt(index);
        selectImgList.add(EditImgModel(path: '', type: ImgType.none));
        setState(() {});
        return true;
      }
    }
    return false;
  }

  // 移除相片
  Future removeAlbumImage(BuildContext context, int index, {
    required Function(String) onErrorDialog
  }) async {
    //移除圖片呼叫
    if (index >= 0 && index < selectImgList.length) {
      //防蠢
      if (selectImgList[index].type == ImgType.urlPath && selectImgList[index].albumsPathInfo != null) {
        WsMemberDeleteAlbumPhotoReq req = WsMemberDeleteAlbumPhotoReq(id: selectImgList[index].albumsPathInfo!.id);
        String resultCodeCheck = '';

        Loading.show(context, '删除中...');
        WsMemberDeleteAlbumPhotoRes res = await ref.read(memberWsProvider).wsMemberDeleteAlbumPhoto(req,
        onConnectSuccess: (msg) {
          resultCodeCheck = msg;
        }, onConnectFail: (errMsg) {
          resultCodeCheck = errMsg;
        });

        if (context.mounted) {
          Loading.hide(context);
        }

        if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
          //這個比較特殊
          //移除掉此格並且補一個空的在最後
          selectImgList.removeAt(index);
          selectImgList.add(EditImgModel(path: '', type: ImgType.none));

          //這個要更新 memberInfo
          if (context.mounted) {
            await _loadMemberInfo(context);
          }

          setState(() {

          });
        } else {
          if (context.mounted) {
            final String errorMessage = ResponseCode.getLocalizedDisplayStr(resultCodeCheck);
            onErrorDialog(errorMessage);
          }
        }
      }
    }
  }

  // 相片拖曳換位置
  Future moveAlbumImage(BuildContext context, afterIndex, beforeIndex) async {

    // 兩張圖片互換 index 位置
    final EditImgModel temp = selectImgList[afterIndex];
    selectImgList[afterIndex] = selectImgList[beforeIndex];
    selectImgList[beforeIndex] = temp;

    final List<EditImgModel> modifiedList =
        selectImgList.where((element) => element.hasPath()).toList();

    final List<AlbumsPathInfo> convertList = modifiedList
        .where((item) => item.albumsPathInfo?.id != null)
        .map((item) {
      return AlbumsPathInfo(
        id: item.albumsPathInfo!.id,
        status: item.albumsPathInfo!.status,
        filePath: item.albumsPathInfo!.filePath,
        fileType: item.albumsPathInfo!.fileType,
      );
    }).toList();

    String resultCodeCheck = '';

    WsMemberMoveAlbumPhotoReq req = WsMemberMoveAlbumPhotoReq(albumsPath: convertList);

    Loading.show(context, '保存中...');

    final WsMemberMoveAlbumPhotoRes res = await ref.read(memberWsProvider).wsMemberMoveAlbumPhoto(req,
      onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
      onConnectFail: (errMsg) => resultCodeCheck = errMsg,
    );

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      if (context.mounted) {
        Loading.hide(context);
        setState((){});
      }
    } else {
      if (context.mounted) BaseViewModel.showToast(context, ResponseCode.map[resultCodeCheck]!);
    }
  }

  selectImage(BuildContext context, {
    required Function() onShowFrequentlyDialog
  }) async {
    //防止連續登入問題 (裁圖/照相功能會造成斷線)
    if (ref.read(commApiProvider).isLegalForNextLogin()) {
      final XFile? xFile = await ImagePickerUtil.selectImage();
      final CroppedFile? croppedFile = await ImagePickerUtil.cropImage(xFile);
      selectAvatar = (croppedFile == null) ? null : File(croppedFile.path);
      isNewAvatar = true;
      setState(() {});
    } else {
      onShowFrequentlyDialog();
    }
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
