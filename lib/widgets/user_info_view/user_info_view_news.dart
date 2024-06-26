import 'package:flutter/material.dart';

class UserInfoNews extends StatelessWidget {
  final String assetPath;
  const UserInfoNews({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
          assetPath, //'assets/user_info_view/imagelist1.png',
        ),
      ),
    );
  }
}
