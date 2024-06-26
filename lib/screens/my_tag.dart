import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:frechat/widgets/shared/list/main_wrap.dart';
import 'package:frechat/widgets/shared/loading_animation.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

///我的標籤
class MyTag extends ConsumerStatefulWidget {
  const MyTag({super.key});

  @override
  ConsumerState<MyTag> createState() => _MyTagState();
}

class _MyTagState extends ConsumerState<MyTag> {
  List<String> tagList = [];
  List<Widget> widgetList = [];
  bool isLoading = true;
  List<Color> colorList = [];
  List<String> chooseList = [];

  @override
  void initState() {
    loadTagText();
    colorList = AppColors.tagColorList;
    super.initState();
  }

  Future<void> loadTagText() async {
    String data =
        await rootBundle.loadString('assets/txt/tag.txt'); // 将每行文字添加到List中
    tagList = LineSplitter().convert(data);
    tidyTagWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "我的标签",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textFormBlack,
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: GestureDetector(
            child: const Image(
              width: 24,
              height: 24,
              image: AssetImage('assets/images/back.png'),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: (isLoading)
            ? Center(child: LoadingAnimation.discreteCircle(size: 36))
            : Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: Text('从下方选择标签',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: AppColors.textFormBlack)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    child: MainWrap().wrap(children: widgetList),
                  ),
                  Expanded(child: Container()),
                  saveButton()
                ],
              ));
  }

  void tidyTagWidget() {
    for (int i = 0; i < tagList.length; i++) {
      widgetList.add(tagWidget(tagList[i], i));
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget tagWidget(String content, int index) {
    Color color = AppColors.mainSnowWhite;
    if (chooseList.isNotEmpty) {
      for (int i = 0; i < chooseList.length; i++) {
        if (chooseList[i] == (content)) {
          color = colorList[i];
          break;
        }
      }
    }
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(48)),
        ),
        child: Text(
          content,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textFormBlack),
        ),
      ),
      onTap: () {
        if (chooseList.contains(content)) {
          int index = chooseList.indexOf(content);
          chooseList.removeAt(index);
          chooseList.insert(index, '');
          widgetList = [];
          tidyTagWidget();
        } else {
          if (chooseList.contains('')) {
            int index = chooseList.indexOf('');
            chooseList.removeAt(index);
            chooseList.insert(index, content);
            widgetList = [];
            tidyTagWidget();
          } else {
            if (chooseList.length < 7) {
              setState(() {
                chooseList.add(content);
                widgetList = [];
                tidyTagWidget();
              });
            } else {
              BaseViewModel.showToast(context, '最多选7个');
            }
          }
        }
      },
    );
  }

  Color backgroundColor(int index) {
    if (index < 7) {
      return colorList[index];
    } else {
      return colorList[index % 7];
    }
  }

  //保存
  Widget saveButton() {
    bool saveButtonCanClick = true;
    String elementToCount = '';
    int count = chooseList.where((element) => element == elementToCount).length;
    if (chooseList.isNotEmpty) {
      if (chooseList.length == 1 && chooseList.contains('')) {
        saveButtonCanClick = false;
      } else if (count > 1) {
        saveButtonCanClick = false;
      }
    } else {
      saveButtonCanClick = false;
    }
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 149.5, vertical: 14),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: (saveButtonCanClick)
                  ? [
                      AppColors.mainPink,
                      AppColors.mainPetalPink,
                    ]
                  : [
                      AppColors.mainLightGrey,
                      AppColors.mainLightGrey
                    ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
        child: const Text("保存",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              decoration: TextDecoration.none,
            )),
      ),
      onTap: () {
        Navigator.pop(context, chooseList);
      },
    );
  }
}
