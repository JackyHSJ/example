import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frechat/models/ws_res/notification/ws_notification_search_list_res.dart';
import 'package:frechat/screens/chatroom/chatroom_viewmodel.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/global/shared_preferance.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/shared/dialog/check_dialog.dart';
import 'package:frechat/widgets/shared/buttons/gradient_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/widgets/shared/dialog/comm_dialog.dart';
import 'package:frechat/widgets/shared/rounded_textfield.dart';
import 'package:frechat/widgets/theme/app_color_theme.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_image_theme.dart';
import 'package:frechat/widgets/theme/app_linear_gradient_theme.dart';
import 'package:frechat/widgets/theme/app_text_theme.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class CommonLanguage extends ConsumerStatefulWidget {
  final ChatRoomViewModel? chatRoomViewModel;
  final SearchListInfo? searchListInfo;
  final num? unRead;

  const CommonLanguage({
    Key? key,
    this.chatRoomViewModel,
    this.searchListInfo,
    this.unRead
  }) : super(key: key);

  @override
  ConsumerState<CommonLanguage> createState() => _CommonLanguageState();
}

class _CommonLanguageState extends ConsumerState<CommonLanguage> {
  List<String> defaultCommonLanguageTexts = []; //資料庫常用語
  List<String> showCommonLanguageTexts = []; //要顯示常用語
  List<String> customCommonLanguageTexts = []; //自定義常用語
  bool isLoading = true;
  String phoneNumber = '';
  final TextEditingController textEditController = TextEditingController();
  StreamController<int>? streamController;
  int textCount = 0;

  late AppTheme _theme;
  late AppColorTheme appColorTheme;
  late AppImageTheme appImageTheme;
  late AppTextTheme appTextTheme;
  late AppLinearGradientTheme appLinearGradientTheme;


  @override
  void initState() {
    super.initState();
    loadDefaultCommonLanguageTexts();
  }

  Future<void> loadDefaultCommonLanguageTexts() async {
    phoneNumber = await FcPrefs.getPhoneNumber();
    customCommonLanguageTexts = await FcPrefs.getCustomCommonLanguage(
        "${phoneNumber}_customCommonLanguage");
    List<String> cacheDefultList = await FcPrefs.getDefaultCommonLanguage(
        '${phoneNumber}_defaultCommonLanguage');
    final num? gender = ref.read(userInfoProvider).memberInfo?.gender;
    String data = '';
    if (gender == 1) {
      data = await rootBundle.loadString('assets/txt/commonlanguage_male.txt');
    } else {
      data =
          await rootBundle.loadString('assets/txt/commonlanguage_female.txt');
    }
    defaultCommonLanguageTexts = const LineSplitter().convert(data);
    if (customCommonLanguageTexts.isEmpty) {
      if (cacheDefultList.isEmpty) {
        for (int i = 0; i < 10; i++) {
          showCommonLanguageTexts.add(defaultCommonLanguageTexts[i]);
        }
      } else {
        showCommonLanguageTexts = cacheDefultList;
      }
    } else {
      if (cacheDefultList.isEmpty) {
        showCommonLanguageTexts.addAll(customCommonLanguageTexts);
        for (int i = 0; i < 10; i++) {
          showCommonLanguageTexts.add(defaultCommonLanguageTexts[i]);
        }
      } else {
        showCommonLanguageTexts.addAll(customCommonLanguageTexts);
        showCommonLanguageTexts.addAll(cacheDefultList);
      }
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    appTextTheme = _theme.getAppTextTheme;
    appColorTheme = _theme.getAppColorTheme;
    appImageTheme = _theme.getAppImageTheme;
    appLinearGradientTheme = _theme.getAppLinearGradientTheme;

    return PopScope(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: appColorTheme.appBarBackgroundColor,
            title: Text(
              "聊天常用语",
              style: appTextTheme.appbarTextStyle,
            ),
            centerTitle: true,
            leading: GestureDetector(
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Image(
                  image: AssetImage(appImageTheme.iconBack),
                ),
              ),
              onTap: () {
                List<String> list = [];
                for (int i = 0; i < showCommonLanguageTexts.length; i++) {
                  if (customCommonLanguageTexts
                      .contains(showCommonLanguageTexts[i]) ==
                      false) {
                    list.add(showCommonLanguageTexts[i]);
                  }
                }
                FcPrefs.setDefaultCommonLanguage(
                    '${phoneNumber}_defaultCommonLanguage', list);
                FcPrefs.setCustomCommonLanguage(
                    "${phoneNumber}_customCommonLanguage",
                    customCommonLanguageTexts);
                Navigator.pop(context);
              },
            ),
            actions: [
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(right: 24.w),
                  child: Image(
                    width: 24.w,
                    height: 24.w,
                    color: appColorTheme.commonLanguageAddIconColor,
                    image: const AssetImage('assets/images/icon_add.png'),
                  ),
                ),
                onTap: () {
                  if (customCommonLanguageTexts.length > 4) {
                    BaseViewModel.showToast(context, "常用语已达上限，请删除后继续添加");
                  } else {
                    streamController = StreamController();
                    customCommonLanguageDialog();
                  }
                },
              ),
            ],
          ),
          body: (isLoading)
              ? const Center(child: CircularProgressIndicator())
              : Container(
            color: appColorTheme.baseBackgroundColor,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                        color: AppColors.mainLightGrey,
                      ),
                      shrinkWrap: true, // 让 ListView 根据内容自适应高度
                      itemCount: showCommonLanguageTexts.length,
                      itemBuilder: (context, index) {
                        if (customCommonLanguageTexts
                            .contains(showCommonLanguageTexts[index])) {
                          return InkWell(
                              child: customCommonLanguageWidget(
                                  showCommonLanguageTexts[index]),
                              onTap: (){
                                String content = showCommonLanguageTexts[index];
                                widget.chatRoomViewModel?.sendTextMessage(searchListInfo: widget.searchListInfo, message: content, contentType: 0);
                                Navigator.pop(context);
                              }
                          );
                        } else {
                          return InkWell(
                              child: commonLanguageTextWidget(
                                  showCommonLanguageTexts[index]),
                              onTap: (){
                                String content = showCommonLanguageTexts[index];
                                widget.chatRoomViewModel?.sendTextMessage(searchListInfo: widget.searchListInfo, message: content, contentType: 0);
                                Navigator.pop(context);
                              }
                          );
                        }
                      },
                    ),
                  ),



                  Container(
                    margin: EdgeInsets.only(
                        left: 28.w, right: 28.w, bottom: 44.h),
                    child: GradientButton(
                      radius: 24.w,
                      height: 44.w,
                      text: '換一批',
                      gradientColorBegin:appLinearGradientTheme.buttonPrimaryColor.colors[0],
                      gradientColorEnd:appLinearGradientTheme.buttonPrimaryColor.colors[1],
                      textStyle: appTextTheme.buttonPrimaryTextStyle,
                      onPressed: () {
                        setState(() {
                          List<String> randomList = getRandomElements(
                              defaultCommonLanguageTexts, 10);
                          showCommonLanguageTexts.clear();
                          if (customCommonLanguageTexts.isNotEmpty) {
                            showCommonLanguageTexts
                                .addAll(customCommonLanguageTexts);
                          }
                          showCommonLanguageTexts.addAll(randomList);
                          print(showCommonLanguageTexts);
                          setState(() {});
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      onPopInvoked : (didPop){
        if(didPop){
          List<String> list = [];
          for (int i = 0; i < showCommonLanguageTexts.length; i++) {
            if (customCommonLanguageTexts
                .contains(showCommonLanguageTexts[i]) ==
                false) {
              list.add(showCommonLanguageTexts[i]);
            }
          }
          FcPrefs.setDefaultCommonLanguage(
              '${phoneNumber}_defaultCommonLanguage', list);
          FcPrefs.setCustomCommonLanguage(
              "${phoneNumber}_customCommonLanguage",
              customCommonLanguageTexts);
        }
      },

    );
  }

  //常用語文字組件
  Widget commonLanguageTextWidget(String content) {
    return Text(content,
        style: appTextTheme.commonLanguagePageTextStyle);
  }

  //換一批
  List<String> getRandomElements(List<String> list, int numElements) {
    if (numElements >= list.length) {
      // 如果要选择的元素数量大于或等于List的长度，直接返回整个List
      return list;
    } else {
      List<String> tempList = List.from(list); // 创建一个List的副本，以免修改原始列表
      tempList.shuffle(); // 随机打乱List中的元素
      return tempList.sublist(0, numElements); // 返回打乱后的List的前numElements个元素
    }
  }

  //自訂義常用語彈窗
  Future<void> customCommonLanguageDialog() async {
    final AppTheme theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    final AppColorTheme appColorTheme = theme.getAppColorTheme;
    final AppLinearGradientTheme appLinearGradientTheme = theme.getAppLinearGradientTheme;
    final AppTextTheme appTextTheme = theme.getAppTextTheme;
    CommDialog(context).build(
      theme: _theme,
      backgroundColor: appColorTheme.dialogBackgroundColor,
      leftLinearGradient: appLinearGradientTheme.buttonSecondaryColor,
      rightLinearGradient: appLinearGradientTheme.buttonPrimaryColor,
      leftTextStyle: appTextTheme.buttonSecondaryTextStyle,
      rightTextStyle: appTextTheme.buttonPrimaryTextStyle,
      title: '自定义常用语',
      contentDes: '',
      leftBtnTitle: '取消',
      rightBtnTitle: '确定',
      widget: _buildContentWidget(),
      leftAction: () {
        BaseViewModel.popPage(context);
        streamController!.close();
        textEditController.text = '';
        textCount = 0;
      },
      rightAction: () async {
        String phoneNumber = await FcPrefs.getPhoneNumber();
        customCommonLanguageTexts.insert(0, textEditController.text);
        showCommonLanguageTexts.insert(0, textEditController.text);
        FcPrefs.setCustomCommonLanguage("${phoneNumber}_customCommonLanguage", customCommonLanguageTexts);
        if (context.mounted) {
          BaseViewModel.popPage(context);
          textEditController.text = '';
          textCount = 0;
        }
        streamController!.close();
        setState(() {});
      }
    );
  }



  Widget _buildContentWidget(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('将显示在聊天页面上，方便快速传送'),
        const SizedBox(height: 12),
        _inputCustomTextField()
      ],
    );
  }

  Widget _inputCustomTextField() {
    return Stack(
      children: [
        SizedBox(
          height:  100.h,
          child: TextField(
            controller: textEditController,
            expands: true,
            maxLines: null,
            maxLength: 50,
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
              counterText: '',
              hintText: '请输入...',
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColors.mainGrey,
                fontSize: 14.sp,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide:
                const BorderSide(color: AppColors.mainLightGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide:
                const BorderSide(color: AppColors.mainLightGrey),
              ),
            ),
            onChanged: (v) {
              streamController!.add(textEditController.text.length);
              textCount = textEditController.text.length;
            },
          ),
        ),
        StreamBuilder<int>(
          stream: streamController!.stream,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return Positioned(
              right: 12,
              bottom: 10,
              child: Text(
                "$textCount/50",
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.mainGrey,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  //自訂義常用語文字組件
  Widget customCommonLanguageWidget(String content) {
    String showContent = content.replaceAll("\n", " ");

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10.w),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                decoration: BoxDecoration(
                  gradient: appLinearGradientTheme.commonLanguageCustomTagColor,
                  borderRadius: const BorderRadius.all(Radius.circular(48.0)),
                ),
                child: const Text(
                  "自定义",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 150.w,
                child: Text(showContent,
                    textDirection: TextDirection.ltr,
                    softWrap: true,
                    style: appTextTheme.commonLanguagePageTextStyle),
              )
            ],
          ),
          InkWell(
            child: Image(
              width: 24.w,
              height: 24.w,
              color: appColorTheme.commonLanguageCustomDeleteIconColor,
              image: const AssetImage('assets/images/icon_garbagecan.png'),
            ),
            onTap: () {
              customCommonLanguageTexts.remove(content);
              showCommonLanguageTexts.remove(content);
              FcPrefs.setCustomCommonLanguage(
                  "${phoneNumber}_customCommonLanguage",
                  customCommonLanguageTexts);
              setState(() {});
            },
          )
        ],
      );
  }
}
