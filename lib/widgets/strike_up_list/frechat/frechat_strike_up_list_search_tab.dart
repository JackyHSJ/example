import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/screens/strike_up_list/strike_up_list_search_tab_view_model.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/system/constant/enum.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/task_manager/task_manager.dart';
import 'package:frechat/widgets/shared/img_util.dart';
import 'package:frechat/widgets/shared/rounded_textfield.dart';
import 'package:frechat/widgets/strike_up_list/frechat/frechat_strike_up_list_card.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:frechat/widgets/theme/app_theme.dart';

class FrechatStrikeUpListSearchTab extends ConsumerStatefulWidget {

  const FrechatStrikeUpListSearchTab({super.key,});

  @override
  ConsumerState<FrechatStrikeUpListSearchTab> createState() => _FrechatStrikeUpListSearchTabState();
}

class _FrechatStrikeUpListSearchTabState extends ConsumerState<FrechatStrikeUpListSearchTab> {

  late StrikeUpListSearchTabViewModel viewModel;

  // 搜尋 ID
  final TextEditingController _textEditController = TextEditingController();
  final FocusNode _textInputFocus = FocusNode();

  late AppTheme _theme;

  @override
  void initState() {
    viewModel = StrikeUpListSearchTabViewModel(setState: setState, ref: ref);
    viewModel.init();
    _textInputFocus.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _textEditController.dispose();
    _textInputFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
    return InkWell(
      onTap: () {
        BaseViewModel.clearAllFocus();
      },
      child: Column(
        children: [
          _searchTextField(),
          _searchContent()
        ],
      ),
    );
  }
  /// 搜尋輸入框
  Widget _searchTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: RoundedTextField(
        margin: EdgeInsets.zero,
        radius: 12,
        textEditingController: _textEditController,
        focusNode: _textInputFocus,
        borderColor: _theme.getAppColorTheme.textFieldBorderColor,
        textInputType: TextInputType.text,
        prefixIcon: _searchTextFieldPrefixIconButton(),
        suffixIcon: _searchTextFieldSuffixIconButton(),
        hint: '输入成员 ID',
        hintTextStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: AppColors.mainGrey,
        ),
        onChange: (text) {
          setState(() {});
        },
      ),
    );
  }
  /// 搜尋輸入框 - 放大鏡icon
  Widget _searchTextFieldPrefixIconButton(){
    return Icon(Icons.search, color: AppColors.mainGrey, size: 24.w,);
  }

  /// 搜尋輸入框 - 搜尋 & 清空icon
  Widget _searchTextFieldSuffixIconButton(){
    if(_textEditController.text.isNotEmpty && !_textInputFocus.hasFocus){
      return Padding(
        padding: EdgeInsets.all(13.h),
        child: InkWell(
          child:const Image(image: AssetImage('assets/images/icon_text_file_cancel.png')),
          onTap: () {
            _textEditController.text = '';
            viewModel.fateListInfo = null;
            setState(() {});
          },
        ),
      );
    }
    return TextButton(
      onPressed: () {
        viewModel.fateListInfo = null;
        if (_textEditController.text.isEmpty) {
          BaseViewModel.showToast(context, '请输入成员ID');
        } else {
          viewModel.searchMemberInfo(userName: _textEditController.text);
        }
        setState(() {FocusScope.of(context).requestFocus(FocusNode());});

      },
      child: Text('搜寻', style: TextStyle(fontSize:14.sp,fontWeight: FontWeight.w700, color: _theme.getAppColorTheme.strikeupSearchTextFieldSearchBtnColor),),
    );
  }

  /// 搜尋內容
  Widget _searchContent(){
    return viewModel.fateListInfo == null
        ? _searchEmptyContent()
        : FrechatStrikeUpListCard(fateListInfo: viewModel.fateListInfo!, taskManager: viewModel.taskManager);
  }

  /// 搜尋內容 - 無資料內容
  Widget _searchEmptyContent() {
    String searchEmptyPath =_theme.getAppImageTheme.strikeUpListSearchEmpty;

    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImgUtil.buildFromImgPath(searchEmptyPath, width: 150.w, height: 150.w),
                Text('没有搜寻结果', style: _theme.getAppTextTheme.strikeUpSearchEmptyTitleTextStyle),
                Text('忘记了吗？再试试看别的吧', style: _theme.getAppTextTheme.strikeUpSearchEmptySubTitleTextStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
