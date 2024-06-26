import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/models/ws_res/greet/ws_greet_module_list_res.dart';
import 'package:frechat/screens/profile/edit/audio/personal_edit_audio_view_model.dart';
import 'package:frechat/screens/profile/greet/add/personal_greet_add_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/audio_util.dart';
import 'package:frechat/system/util/cache_network_image_util.dart';
import 'package:frechat/widgets/shared/app_bar.dart';
import 'package:frechat/widgets/shared/bottom_sheet/common_bottom_sheet.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/main_scaffold.dart';
import 'package:frechat/widgets/shared/main_textfield.dart';
import 'package:frechat/widgets/shared/record/record_time.dart';
import 'package:frechat/widgets/shared/record/record_time_view_model.dart';
import 'package:frechat/widgets/theme/app_box_decoration_theme.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../../../../widgets/constant_value.dart';
import '../../../../widgets/theme/original/app_colors.dart';
import '../../../../widgets/theme/uidefine.dart';

class PersonalGreetAdd extends ConsumerStatefulWidget {
  const PersonalGreetAdd({
    super.key,
    required this.moduleNameList,
    this.model,
    required this.type,
  });
  final List<GreetModuleInfo> moduleNameList;
  final GreetType type;
  final GreetModuleInfo? model;

  @override
  ConsumerState<PersonalGreetAdd> createState() => _PersonalGreetAddState();
}

class _PersonalGreetAddState extends ConsumerState<PersonalGreetAdd> with TickerProviderStateMixin {
  late PersonalGreetAddViewModel viewModel;
  GreetType get type => widget.type;
  GreetModuleInfo? get model => widget.model;
  List<GreetModuleInfo> get moduleNameList => widget.moduleNameList;
  late AppTheme _theme;
  late AppColorTheme _appColorTheme;
  late AppImageTheme _appImageTheme;
  late AppBoxDecorationTheme _appBoxDecorationTheme;
  late AppTextTheme _appTextTheme;

  @override
  void initState() {
    viewModel = PersonalGreetAddViewModel(ref: ref, setState: setState);
    viewModel.init(context, model: model, moduleNameList: moduleNameList);
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
    final String title = (type == GreetType.update) ? '编辑模板' : '新建模板';
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    _appColorTheme = _theme.getAppColorTheme;
    _appImageTheme = _theme.getAppImageTheme;
    _appBoxDecorationTheme = _theme.getAppBoxDecorationTheme;
    _appTextTheme = _theme.getAppTextTheme;

    return MainScaffold(
      isFullScreen: true,
      padding: EdgeInsets.only(top: paddingHeight, bottom: UIDefine.getNavigationBarHeight(), left: WidgetValue.horizontalPadding, right: WidgetValue.horizontalPadding),
      appBar: MainAppBar(
        theme: _theme,
        backgroundColor: _appColorTheme.appBarBackgroundColor,
        title: title,
        leading: IconButton(
          icon: ImgUtil.buildFromImgPath(_appImageTheme.iconBack, size: 24.w),
          onPressed: () => BaseViewModel.popPage(context),
        ),
        actions: [_buildDeleteBtn()],
      ),
      backgroundColor: _appColorTheme.baseBackgroundColor,
      child: WillPopScope(
        onWillPop: () async {
          return !ModalRoute.of(context)!.canPop;
        },
        child: Column(
          children: [
            SizedBox(height:20),
            _buildGreetImg(),
            SizedBox(height:20),
            _buildModuleNameTextField(),
            _buildIntroTextField(),
            _buildRecord(),
            SizedBox(height: WidgetValue.btnBottomPadding),
            _buildBtn(),
            SizedBox(height: WidgetValue.btnBottomPadding)
          ],
        ),
      ),
    );
  }


  _leading() {
    return GestureDetector(
      child: const Image(
        width: 24,
        height: 24,
        image: AssetImage('assets/images/back.png'),
      ),
      onTap: () {
        CommDialog(context).build(
          theme: _theme,
          title: '是否发布模板？',
          contentDes: '您尚未储存模板设定，离开后将不保存',
          leftBtnTitle: '离开',
          rightBtnTitle: '发布',
          leftAction: () {
            BaseViewModel.popPage(context);
            BaseViewModel.popPage(context);
          },
          rightAction: () {
            if(type == GreetType.add) {
              viewModel.addGreet(context);
            } else if(type == GreetType.update) {
              viewModel.updateGreet(context);
            }
          },
        );
      },
    );
  }

  _buildDeleteBtn() {
    return Visibility(
      visible: type == GreetType.update,
      child: InkWell(
        onTap: () {
          CommDialog(context).build(
            theme: _theme,
            title: '删除模板？',
            contentDes: '删除后不可回复',
            leftBtnTitle: '取消',
            rightBtnTitle: '删除',
            leftAction: () {
              BaseViewModel.popPage(context);
              BaseViewModel.popPage(context);
            },
            rightAction: () => viewModel.deleteGreet(context, deleteId: model!.id.toString()),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
          child: const Text('删除', style: TextStyle(color: AppColors.mainRed, fontSize: 18, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  _buildGreetImg() {
    final String? imgPath = viewModel.imgFile?.path;
    return InkWell(
      onTap: () => _albumOrCameraBottomDialog(),
      child: (imgPath == null) ? _buildEmptyUserImg() : _buildGreetImgWay(imgPath),
    );
  }

  _buildGreetImgWay(String imgPath) {
    if (type == GreetType.add) {
      return _buildGreetImgFromImagePicker(imgPath);
    } else if (type == GreetType.update) {
      return _buildGreetFromUrl(imgPath);
    }
  }

  _buildGreetFromUrl(String imgPath) {
    if(viewModel.isUpdateModeUrlImg) {
      return CachedNetworkImageUtil.load(HttpSetting.baseImagePath + imgPath,
        size: WidgetValue.userBigImg,
        radius: WidgetValue.btnRadius,
      );
    }
    return _buildGreetImgFromImagePicker(imgPath);
  }

  _buildGreetImgFromImagePicker(String imgPath) {
    return ImgUtil.buildFromImgPath(imgPath,
        size: WidgetValue.userBigImg,
        radius: WidgetValue.btnRadius / 2
    );
  }

  _buildEmptyUserImg() {
    return Container(
      width: WidgetValue.userBigImg,
      height: WidgetValue.userBigImg,
      decoration: _appBoxDecorationTheme.albumCellBoxDecoration,
      child: Center(
        child: ImgUtil.buildFromImgPath(_appImageTheme.iconAddFile, size: 36.w),
      )
    );
  }

  _buildRecord() {
    return RecordTime(audioPath: model?.greetingAudio?.filePath,
      onRecordStatus: (status) {
        viewModel.recordStatus = status;
        setState(() {});
      }
    );
  }

  _buildBtn() {
    final bool imgFileCheck = viewModel.imgFile != null || viewModel.imgFile?.path == '';
    final bool recordStatus = viewModel.recordStatus == SettingRecordStatus.done;
    final bool audioFileCheck = (AudioUtils.filePath != null || AudioUtils.filePath == '') && recordStatus;
    final bool fileCheck = imgFileCheck || audioFileCheck;
    final bool introCheck = viewModel.introTextController.text.isNotEmpty;
    final bool canSendReq = fileCheck == true && introCheck == true;

    Decoration btnBgColor = canSendReq ? _appBoxDecorationTheme.btnConfirmBoxDecoration : _appBoxDecorationTheme.btnDisableBoxDecoration;
    Color btnTextColor = canSendReq ? _appColorTheme.btnConfirmTextColor : _appColorTheme.btnDisableTextColor;
    return InkWell(
      onTap: () {
        if(canSendReq == false) {
          BaseViewModel.showToast(context, '亲～输入资料不齐全呦');
        }
        
        if(viewModel.isClick == false && canSendReq){
          if(type == GreetType.add) {
            viewModel.addGreet(context);
          } else if(type == GreetType.update && canSendReq) {
            viewModel.updateGreet(context);
          }
        }
      },
      child: Container(
        width: UIDefine.getWidth(),
        height: 48,
        alignment: Alignment.center,
        decoration: btnBgColor,
        child: Text('发布', style: TextStyle(color: btnTextColor, fontSize: 14, fontWeight: FontWeight.w500))
      ),
    );
  }

  _buildModuleNameTextField() {
    return MainTextField(
        hintText: '请输入模板名称...',
        controller: viewModel.moduleNameTextController,
        backgroundColor: _appColorTheme.textFieldBackgroundColor,
        borderColor: _appColorTheme.textFieldBorderColor,
        fontColor: _appTextTheme.normalMainTextFieldTextStyle.color,
        fontWeight: _appTextTheme.normalMainTextFieldTextStyle.fontWeight,
        fontSize: _appTextTheme.normalMainTextFieldTextStyle.fontSize,
        hintStyle: _appTextTheme.normalMainTextFieldHintTextStyle,
        radius: 10,
        maxLength: 4,
        onChanged: (_) => setState(() {})
    );
  }

  _buildIntroTextField() {
    return MainTextField(
      textFieldHeight: WidgetValue.bigTextFieldHeight,
      hintText: '请输入文字内容文案…',
      controller: viewModel.introTextController,
      backgroundColor: _appColorTheme.textFieldBackgroundColor,
      borderColor: _appColorTheme.textFieldBorderColor,
      fontColor: _appTextTheme.normalMainTextFieldTextStyle.color,
      fontWeight: _appTextTheme.normalMainTextFieldTextStyle.fontWeight,
      fontSize: _appTextTheme.normalMainTextFieldTextStyle.fontSize,
      hintStyle: _appTextTheme.normalMainTextFieldHintTextStyle,
      radius: 10,
      enableMultiLines: true,
      maxLength: 50,
      onChanged: (_) => setState(() {})
    );
  }

  void _albumOrCameraBottomDialog() {
    CommonBottomSheet.show(
      context,
      title: '上传相片',
      actions: [
        CommonBottomSheetAction(
          title: '开启相机',
          onTap: () {
            viewModel.takeImg(context, onShowFrequentlyDialog: () async => await _buildFrequentlyDialog());
            BaseViewModel.popPage(context);
          },
        ),
        CommonBottomSheetAction(
          title: '从相簿中选择',
          onTap: () {
            viewModel.selectImg(context, onShowFrequentlyDialog: () async => await _buildFrequentlyDialog());
            BaseViewModel.popPage(context);
          },
        ),
      ],
    );
  }

  Future<void> _buildFrequentlyDialog() async {
    await CheckDialog.show(
        context,
        appTheme: _theme,
        titleText: '操作过于频繁',
        messageText: '请稍候 5 秒',
        confirmButtonText: '确认'
    );
  }
}