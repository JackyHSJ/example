import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';

import '../../widgets/shared/buttons/gradient_button.dart';

class TaskCenterView extends StatefulWidget {
  const TaskCenterView({super.key});

  @override
  State<TaskCenterView> createState() => _TaskCenterViewState();
}

class _TaskCenterViewState extends State<TaskCenterView> {
  //測試用資料
  List<TaskListTile> clt = [
    TaskListTile(coin: 20, titleTxt: '完善资料', subtitleTxt: '资料完善度100%奖励'),
    TaskListTile(coin: 20, titleTxt: '上传头像', subtitleTxt: '上传本人头像'),
    TaskListTile(coin: 20, titleTxt: '完善相册', subtitleTxt: '至少上传4张你的照片'),
    TaskListTile(coin: 20, titleTxt: '个性签名', subtitleTxt: '完善自我介绍'),
  ];
  List<TaskListTile> clt2 = [
    TaskListTile(coin: 20, titleTxt: '搭讪小姐姐', subtitleTxt: '资料完善度100%奖励'),
    TaskListTile(coin: 20, titleTxt: '邀请好友', subtitleTxt: '上传本人头像'),
    TaskListTile(coin: 20, titleTxt: '视频通话', subtitleTxt: '与缘分小姐姐视频聊天'),
    TaskListTile(coin: 20, titleTxt: '语音通话', subtitleTxt: '给喜欢的女生语音'),
    TaskListTile(coin: 20, titleTxt: '发送私信', subtitleTxt: '给喜欢的女生发私信'),
    TaskListTile(coin: 20, titleTxt: '发布动态', subtitleTxt: '发布最新动态'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 218, 191, 0.8),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('任务中心', style: TextStyle(fontSize: 16, color: AppColors.textFormBlack, fontWeight: FontWeight.w600)),
        centerTitle: true, // 将标题居中
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromRGBO(255, 218, 191, 0.8), Color.fromRGBO(255, 175, 204, 0.5), Color.fromRGBO(255, 255, 255, 0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned(top: 20, right: 0, child: Image.asset('assets/task_center_view/icon_bg_img.png')),
            SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset('assets/strike_up_list/ic_money.png'),
                  const Text('我的金币', style: TextStyle(fontSize: 14, color: Color.fromRGBO(255, 190, 63, 1), fontWeight: FontWeight.w600)),
                  const Text('150000', style: TextStyle(fontSize: 28, color: Color.fromRGBO(255, 190, 63, 1), fontWeight: FontWeight.w600)),
                  //任務部件
                  task('新手任务', '每个任务只能完成一次', clt),
                  //任務部件
                  task('每日任务', '描述', clt2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///任務部件
  Widget task(String caption, String directions, List<TaskListTile> taskListTile) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(29, 20, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(caption, style: const TextStyle(fontSize: 14, color: AppColors.textFormBlack, fontWeight: FontWeight.w600)),
                  Text(directions, style: const TextStyle(fontSize: 12, color: AppColors.textFormBlack)),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: const Color.fromRGBO(255, 255, 255, 0.9),
              border: Border.all(
                color: AppColors.mainLightGrey,
                width: 1,
              ),
            ),
            child: ListView.builder(
              shrinkWrap: true, // 让ListView自适应内容高度
              physics: const NeverScrollableScrollPhysics(), // 禁止ListView滚动
              itemCount: taskListTile.length, // 根据实际数据源的长度设置
              itemBuilder: (context, index) {
                return ListTile(
                  //titleAlignment: ListTileTitleAlignment.center,
                  //isThreeLine: true,
                  title: taskListTile[index].title,
                  subtitle: taskListTile[index].subtitle,
                  trailing: taskListTile[index].trailing,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

///任務物件（按鈕待更新
class TaskListTile {
  int _coin = 0;
  String _titleTxt = '';
  String _subtitleTxt = '';

  TaskListTile({
    required int coin,
    required String titleTxt,
    required String subtitleTxt,
  }) {
    _coin = coin;
    _titleTxt = titleTxt;
    _subtitleTxt = subtitleTxt;
  }

  Widget get title {
    return Row(
      children: [
        Image.asset('assets/strike_up_list/ic_money.png'),
        Text('+$_coin', style: const TextStyle(color: Color.fromRGBO(255, 190, 63, 1), fontSize: 16)),
      ],
    );
  }

  Widget get subtitle {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_titleTxt, style: const TextStyle(color: AppColors.textFormBlack, fontWeight: FontWeight.w600)),
        Text(_subtitleTxt, style: const TextStyle(color: AppColors.mainDark)),
      ],
    );
  }

  Widget get trailing {
    return SizedBox(
        width: 52,
        child: GradientButton(
          text: '前往',
          radius: 48,
          height: 32,
          textStyle: const TextStyle(color: Colors.white, fontSize: 12),
          gradientColorBegin: const Color.fromRGBO(255, 49, 121, 1),
          gradientColorEnd: const Color.fromRGBO(255, 49, 121, 1),
        ));
  }
}
