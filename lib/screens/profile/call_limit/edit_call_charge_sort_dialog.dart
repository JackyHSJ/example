
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/widgets/constant_value.dart';
import 'package:frechat/widgets/shared/buttons/common_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

class EditCallChargeSortDialog extends ConsumerStatefulWidget {

  const EditCallChargeSortDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<EditCallChargeSortDialog> createState() => _EditCallChargeSortDialogState();
}

class _EditCallChargeSortDialogState extends ConsumerState<EditCallChargeSortDialog> {
  late List<DragAndDropList> _contents;


  @override
  void initState() {
    super.initState();

    _contents = List.generate(10, (index) {
      return DragAndDropList(
        children: <DragAndDropItem>[
          DragAndDropItem(
            child: Text('$index.1'),
          ),
          DragAndDropItem(
            child: Text('$index.2'),
          ),
          DragAndDropItem(
            child: Text('$index.3'),
          ),
        ],
      );
    });
    // _contents = [DragAndDropList(
    //   children: <DragAndDropItem>[
    //     DragAndDropItem(
    //         child: item('不限对象免费通话额度', true)
    //     ),
    //   ],
    // ),DragAndDropList(
    //   children: <DragAndDropItem>[
    //     DragAndDropItem(
    //         child: item('VIP 限定免费通话额度', true)
    //     ),
    //   ],
    // ),DragAndDropList(
    //   children: <DragAndDropItem>[
    //     DragAndDropItem(
    //         child: item('限定对象免费通话额度', true)
    //     ),
    //   ],
    // ),DragAndDropList(
    //   children: <DragAndDropItem>[
    //     DragAndDropItem(
    //         child: item('使用金币', true)
    //     ),
    //   ],
    // )];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.whiteBackGround,
      surfaceTintColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: WidgetValue.horizontalPadding),
      actionsPadding: const EdgeInsets.only(right: 16, bottom: 20, left: 16),
      titlePadding: const EdgeInsets.only(top: 20, right: 16, left: 16),
      // title: _buildTitle(),
      content: _buildContent(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      actionsAlignment: MainAxisAlignment.center,
      // actions: [_buildAction()],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(WidgetValue.btnRadius),
      ),
    );
  }

  Widget _buildTitle(){
    return Container(
      alignment: Alignment.center,
      child: Text('设置使用排序',style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.sp,
          color: Color.fromRGBO(68, 70, 72, 1)
      )),
    );
  }

  Widget _buildContent(){
    return DragAndDropLists(
            children: _contents,
            onItemReorder: _onItemReorder,
            onListReorder: _onListReorder,
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _contents.removeAt(oldListIndex);
      _contents.insert(newListIndex, movedList);
    });
  }

  Widget item(String title,bool isFree){
    return Row(
      children: [
        Image(
          width: 44.w,
          height: 16.h,
          image: const AssetImage('assets/images/icon_free_tag.png'),
        ),
        Text(title,
            style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(68, 70, 72, 1)
            )),
        Expanded(child: SizedBox()),
        Image(
          width: 24.w,
          height: 24.w,
          image: const AssetImage(
              'assets/images/icon_sort_item.png'),
        )
      ],
    );
  }

  Widget _buildAction() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: _buildLeftBtn(
            title: '取消',
            action: () {
              BaseViewModel.popPage(context);
            },
          ),
        ),
        SizedBox(width: WidgetValue.separateHeight),
        Expanded(
          child: _buildRightBtn(
            title: '确定',
            action: () async {
              BaseViewModel.popPage(context);
            },
          ),
        ),
      ],
    );
  }

  _buildLeftBtn({
    String? title,
    TextStyle? textStyle,
    LinearGradient? linearGradient,
    Border? broder,
    required Function() action
  }) {

    if (title == null){
      return Container();
    }

    return CommonButton(
      onTap: () => action(),
      btnType: CommonButtonType.text,
      cornerType: CommonButtonCornerType.round,
      isEnabledTapLimitTimer: false,
      text: title,
      textStyle: textStyle ?? const TextStyle(color:  AppColors.mainPink, fontWeight: FontWeight.w400),
      colorBegin: linearGradient?.colors[0] ?? AppColors.pinkLightGradientColors.colors[0].withOpacity(0.1),
      colorEnd: linearGradient?.colors[1] ??  AppColors.pinkLightGradientColors.colors[1].withOpacity(0.1),
      colorAlignmentBegin: linearGradient?.begin ??Alignment.topCenter,
      colorAlignmentEnd: linearGradient?.end ?? Alignment.bottomCenter,
      broder: broder ,
    );
  }

  _buildRightBtn({
    String? title,
    TextStyle? textStyle,
    LinearGradient? linearGradient,
    Border? broder,
    required Function() action
  }) {
    return CommonButton(
      onTap: () => action(),
      btnType: CommonButtonType.text,
      cornerType: CommonButtonCornerType.round,
      isEnabledTapLimitTimer: false,
      text: title,
      textStyle: textStyle ?? const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      colorAlignmentBegin: linearGradient?.begin ??Alignment.topCenter,
      colorAlignmentEnd: linearGradient?.end ?? Alignment.bottomCenter,
      broder: broder ,
    );
  }

}
