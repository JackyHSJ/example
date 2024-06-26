import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/home/home.dart';
import 'package:frechat/screens/profile/edit/personal_edit_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/repository/response_code.dart';
import 'package:frechat/system/util/image_picker_util.dart';
import 'package:frechat/widgets/profile/cell/personal_edit_img_cell.dart';
import 'package:frechat/widgets/shared/list/grid_list.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

import '../../models/req/report/report_user_req.dart';
import '../../models/res/report_user_res.dart';
import '../../models/ws_req/report/ws_report_search_type_req.dart';
import '../../models/ws_res/report/ws_report_search_type_res.dart';
import '../../system/base_view_model.dart';
import '../../system/global/shared_preferance.dart';
import '../../system/providers.dart';
import '../../widgets/shared/dialog/check_dialog.dart';
import '../../widgets/shared/buttons/gradient_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserInfoViewReportView extends ConsumerStatefulWidget {
  final num userId;
  const UserInfoViewReportView({super.key, required this.userId});

  @override
  ConsumerState<UserInfoViewReportView> createState() =>
      _UserInfoViewReportViewState();
}

class _UserInfoViewReportViewState
    extends ConsumerState<UserInfoViewReportView> {
  late ReportUserRes rur;
  late WsReportSearchTypeRes wsReportSearchTypeRes;
  late List<ReportListInfo> listReportListInfo = [];
  late List<reportItem> listReportItem = [];
  TextEditingController textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int textCount = 0;
  List<EditImgModel> selectImgList = [
    EditImgModel(path: '', type: ImgType.none)
  ];
  bool isLoading = true;
  AppTheme? theme;
  late AppColorTheme appColorTheme;
  late AppImageTheme appImageTheme;
  late AppTextTheme appTextTheme;
  late AppLinearGradientTheme appLinearGradientTheme;

  @override
  void initState() {
    super.initState();
    getListData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 查詢舉報類型 api 6-1
  getListData() async {
    String? resultCodeCheck;

    // 舉報類型 0:全部 1:用戶 2:動態
    final WsReportSearchTypeReq reqBody =
        WsReportSearchTypeReq.create(type: '1');
    final WsReportSearchTypeRes res = await ref
        .read(reportWsProvider)
        .wsReportSearchType(reqBody,
            onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
            onConnectFail: (errMsg) =>
                BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      setState(() {
        listReportListInfo = res.list ?? [];
        for (var lrli in listReportListInfo) {
          listReportItem
              .add(reportItem(txt: lrli.reason ?? '', id: lrli.id ?? 0));
        }
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appColorTheme = theme!.getAppColorTheme;
    appImageTheme = theme!.getAppImageTheme;
    appTextTheme = theme!.getAppTextTheme;
    appLinearGradientTheme = theme!.getAppLinearGradientTheme;
    return Scaffold(
        backgroundColor: appColorTheme.baseBackgroundColor,
        appBar: _buildAppBar(),
        body: GestureDetector(
          onTap: () => _focusNode.unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  const Divider(height: 1),
                  _buildReportList(),
                  const SizedBox(height: 20),
                  _buildReportDesTitle(),
                  _buildReportImages(),
                  _buildReportTextField(),
                  _buildReportBtn(),
                ],
              ),
            ),
          ),
        ));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: appColorTheme.appBarBackgroundColor,
      elevation: 0,
      leading: InkWell(
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Image(
            image: AssetImage(appImageTheme.iconBack),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            '取消',
            style: appTextTheme.reportPageAppBarActionTextStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20.h, bottom: 8.h),
          child: Center(
              child: Image.asset(appImageTheme.reportPageTitleIcon,
                  width: 60.w, height: 60.w)),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 20.h),
          child: Text(
            '您举报的理由是',
            style: TextStyle(
                fontSize: 18.sp,
                color: appColorTheme.reportPageTextColor,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildReportList() {
    return (isLoading)
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: List.generate(
              listReportItem.length,
              (index) => _buildReportItem(listReportItem[index]),
            ),
          );
  }

  Widget _buildReportItem(reportItem item) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              for (var ri in listReportItem) {
                ri.check = false;
              }
              item.check = !item.check;
            });
          },
          child: SizedBox(
            width: double.infinity,
            height: 48.sp,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.txt,
                    style: TextStyle(
                        color: appColorTheme.reportPageTextColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400)),
                _buildReportCheck(item)
              ],
            ),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildReportCheck(reportItem item) {
    return item.check
        ? Image.asset('assets/images/report_check.png', width: 24, height: 24)
        : const SizedBox();
  }

  Widget _buildReportDesTitle() {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text('举报描述（选填）',
            style: TextStyle(
                color: appColorTheme.reportPageTextColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400)));
  }

  Widget _buildReportImages() {
    return MainGridView(
        childAspectRatio: 1,
        crossAxisCount: 4,
        shrinkWrapEnable: true,
        physics: const NeverScrollableScrollPhysics(),
        children: selectImgList.map((img) {
          return InkWell(
            onTap: () => selectMultiImg(),
            child: PersonalEditImgCell(model: img),
          );
        }).toList());
  }

  Widget _buildReportTextField() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 4.h),
          height: 160.h,
          child: TextField(
            controller: textEditingController,
            focusNode: _focusNode,
            expands: true,
            maxLines: null,
            maxLength: 100,
            textAlignVertical: TextAlignVertical.top,
            style:  appTextTheme.reportTextFieldTextTextStyle,
            decoration: InputDecoration(
              counterText: '',
              hintText: '提供更多信息有助于举报被快速处理',
              hintStyle: appTextTheme.reportTextFieldHintTextTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide:
                    const BorderSide(color: AppColors.mainLightGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide:  BorderSide(color: appColorTheme.reportTextFieldBorderColor),
              ),
            ),
            onChanged: (v) {
              textCount = textEditingController.text.length;
              setState(() {});
            },
          ),
        ),
        Positioned(
            right: 12,
            bottom: 10,
            child: Text(
              "$textCount/100",
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColors.mainGrey,
              ),
            ))
      ],
    );
  }

  Widget _buildReportBtn() {
    return Padding(
      padding: EdgeInsets.only(top: 48.h),
      child: GradientButton(
        text: '提交',
        gradientColorBegin: appLinearGradientTheme.buttonPrimaryColor.colors[0],
        gradientColorEnd: appLinearGradientTheme.buttonPrimaryColor.colors[1],
        textStyle:appTextTheme.buttonPrimaryTextStyle,
        radius: 24,
        height: 44,
        onPressed: () {
          reportMember();
        },
      ),
    );
  }

  Future reportDialog() async {
    await CheckDialog.show(context,
        appTheme: theme,
        barrierDismissible: false,
        titleText: '举报成功',
        messageText:
            '我们已接收到您的举报内容，非常重视您的举报。每一条举报都会被认真审核，并依据国家法律法规及本平台条款积极处理，感谢您的配合。',
        showCancelButton: true,
        cancelButtonText: '紧急处理',
        confirmButtonText: '确定',
        onCancelPress: () {
          BaseViewModel.popPage(context);
          BaseViewModel.showToast(context, '已為您的举报进入优先排程');
        },
        onConfirmPress: () => BaseViewModel.popPage(context));
  }

  // 舉報 API
  void reportMember() async {
    String resultCodeCheck = '';
    String tId = await FcPrefs.getCommToken();
    final list = listReportItem.where((info) => info.check == true).toList();

    if (list.isEmpty) {
      if (context.mounted) BaseViewModel.showToast(context, '选项尚未选择');
      return;
    }

    List<File>? reportImages = selectImgList
        .map((img) => (img.path.isNotEmpty && img.type == ImgType.filePath)
            ? File(img.path)
            : null)
        .where((file) => file != null)
        .cast<File>()
        .toList();

    final ReportUserReq req = ReportUserReq.create(
        tId: tId,
        type: 1,
        files: reportImages,
        remark: textEditingController.text,
        userId: widget.userId,
        reportSettingId: list[0].id);

    isLoading = true;
    setState(() {});

    final ReportUserRes? res = await ref.read(commApiProvider).reportUser(req,
        onConnectSuccess: (succMsg) => resultCodeCheck = succMsg,
        onConnectFail: (errMsg) =>
            BaseViewModel.showToast(context, ResponseCode.map[errMsg]!));

    if (resultCodeCheck == ResponseCode.CODE_SUCCESS) {
      reportDialog();
      isLoading = false;
      setState(() {});
    }
  }

  // 到相簿選擇圖片
  Future<void> selectMultiImg() async {
    final List<dynamic> selected = await ImagePickerUtil.selectMultiImg();
    int activeReportImages =
        selectImgList.where((item) => item.path != '').length;

    if (selected.isEmpty) return;

    if (selected.length > 4 || activeReportImages >= 4) {
      if (context.mounted) BaseViewModel.showToast(context, '最多上传四张照片');
      return;
    }

    selectImgList.removeWhere((item) => item.path == '');

    for (var img in selected) {
      selectImgList.add(EditImgModel(path: img.path, type: ImgType.filePath));
    }

    if (selectImgList.length < 4) {
      selectImgList.add(EditImgModel(path: '', type: ImgType.none));
    }

    setState(() {});
  }
}

class reportItem {
  String txt;
  bool check;
  num id;
  reportItem({
    required this.txt,
    this.check = false,
    required this.id,
  });
}
