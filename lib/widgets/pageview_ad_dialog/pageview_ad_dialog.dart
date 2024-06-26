import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageViewAdDialog extends StatefulWidget {
  final double statusBarHeight;
  const PageViewAdDialog({Key? key, required this.statusBarHeight})
      : super(key: key);

  @override
  _PageViewAdDialogState createState() => _PageViewAdDialogState();
}

class _PageViewAdDialogState extends State<PageViewAdDialog>
    with SingleTickerProviderStateMixin {
  final List<String> pages = [
    'assets/images/ad_one_poker.png',
    'assets/images/ad_two.png',
    'assets/images/ad_three_poker.png',
  ];

  int currentPage = 1;
  int rotationCount = 0;
  bool isShowBtCancelCanClcik = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: adPageViewImageAndLabel(),
            ),
        ),
        Padding(
          padding:  EdgeInsets.only(top: 16.h, bottom: 36.w),
          child: Center(
            child: (isShowBtCancelCanClcik)
                ? GestureDetector(
                    child: Image(
                      width: 36.w,
                      height: 36.w,
                      image: AssetImage('assets/images/button_cancel.png'),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  )
                : SizedBox(
                    width: 36.w,
                    height: 36.w,
                  ),
          ),
        ),
      ],
    );
  }

  Widget adPageViewImageAndLabel() {
    return Stack(
      children: [
        PageView.builder(
          itemCount: pages.length,
          itemBuilder: (context, index) {
            return Container(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Image(
                  image: AssetImage(pages[index]),
                  fit: BoxFit.contain,
                ),
              ),
            ));
          },
          onPageChanged: (index) {
            setState(() {
              currentPage = index + 1;
              if (currentPage == pages.length) {
                isShowBtCancelCanClcik = true;
              }
            });
          },
        ),
        Positioned(
          top: 8.0,
          right: 8.0,
          child: indexLabel(currentPage),
        ),
      ],
    );
  }

  Widget indexLabel(int currentPage) {
    return Container(
      alignment: const Alignment(0, 0),
      height: 28.h,
      width: 49.w,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.3),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Material(
        type:MaterialType.transparency,
        child: Text(
          "$currentPage" + "/" + pages.length.toString(),
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
