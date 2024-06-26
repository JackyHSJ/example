
import 'package:flutter/material.dart';
import 'package:frechat/models/ws_res/contact/ws_contact_search_list_res.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import '../../../system/repository/http_setting.dart';
import '../../../system/util/avatar_util.dart';
import '../../constant_value.dart';
import 'package:frechat/system/base_view_model.dart';
import 'package:flutter_screenutil/src/size_extension.dart';


class PersonalContactCell extends StatelessWidget {
  PersonalContactCell({super.key, required this.model});
  ContactListInfo model;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 10),
          Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNicknameGenderAgeCer(),
                _buildTags(),
                _buildSelfIntroduction()
              ]
          ),),
        ],
      ),
    );
  }


  _buildAvatar(){

    final num gender = model.gender ?? 0;
    final String avatar =  model.avatarPath ?? '';
    final bool realPersonAuth = model.realPersonAuth == 1;

    return (avatar == '')
      ? AvatarUtil.defaultAvatar(gender, size: 64.w)
      : AvatarUtil.userAvatar(HttpSetting.baseImagePath + avatar, size: 64.w);
  }

  _buildNicknameGenderAgeCer(){
    final name = model.nickName ?? model.userName;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('$name',style: const TextStyle(color: AppColors.mainDark,fontSize: 14.0, fontWeight:FontWeight.w700, height: 1.5),),
        const SizedBox(width: 4),
        Container(
          height: 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99.0),
            color: (model.gender == 0) ? const Color(0xFFFD73A5) : const Color(0xFF54B5DF),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 4,right: 6),
            child: Row(
              children: [
                Image.asset('assets/profile/profile_contact_${model.gender == 0 ? 'female' : 'male'}_icon.png', width: 12, height: 12),
                const SizedBox(width: 2),
                Text('${model.age}',style: const TextStyle(color: Color(0xFFFFFFFF),fontSize: 10.0, fontWeight:FontWeight.w500, height: 1.5),)
              ],
            ),
          ),
        ),
        const SizedBox(width: 4),
        Visibility(
          visible: model.realNameAuth == 1,
          child: Image.asset('assets/profile/profile_contact_name_certi_cyan_icon.png',width: 16, height: 16
          ),
        )
      ],
    );
  }

  _buildTags() {
    bool isHometown = model.hometown != null ? true : false;
    bool isHeight = model.height != null ? true : false;
    bool isWeight = model.weight != null ? true : false;
    bool isOccupation = model.occupation != null ? true : false;


    return Container(
        width: 280.w,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTag(isHometown, model.hometown),
              _buildTag(isHeight, '${model.height} cm'),
              _buildTag(isWeight, '${model.weight} kg'),
              _buildTag(isOccupation, model.occupation),
            ],
          )
    ));
  }

  _buildTag(status, content){
    return Visibility(
      visible: status,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.0),color: const Color(0xFFEAEAEA),),
            child: Padding(
              padding: const EdgeInsets.only(left: 6, right: 6),
              child: Center(
                child: Text('$content',
                  style: const TextStyle(fontSize: 10.0,color: AppColors.mainDark,fontWeight: FontWeight.w400, height: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ) ,
    );
  }

  _buildSelfIntroduction(){
    String selfIntroduction = model?.selfIntroduction ?? '';
    if (selfIntroduction.isEmpty) selfIntroduction = '这个用户还在火星，请呼喊他的名字';
    selfIntroduction = selfIntroduction.replaceAll("\n", " ");
    return Container(
      width: 280.w,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          selfIntroduction.trim(),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.mainDark, fontSize: 12.0, fontWeight:FontWeight.w400, height: 1.5),
        ),
      ),
    );
  }
}