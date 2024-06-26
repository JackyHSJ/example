// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:frechat/models/profile/personal_online_service_model.dart';
// import 'package:frechat/system/base_view_model.dart';
// import 'package:frechat/system/constant/enum.dart';
// import 'package:frechat/system/providers.dart';
// import 'package:frechat/widgets/constant_value.dart';
// import 'package:frechat/widgets/shared/app_bar.dart';
// import 'package:frechat/widgets/shared/img_util.dart';
// import 'package:frechat/widgets/shared/main_scaffold.dart';
// import 'package:frechat/widgets/theme/uidefine.dart';
//
// import '../../../../models/profile/personal_cell_model.dart';
// import 'package:frechat/widgets/theme/app_color_theme.dart';
// import 'package:frechat/widgets/theme/app_image_theme.dart';
// import 'package:frechat/widgets/theme/app_theme.dart';
//
// class PersonalOnlineServiceLaw extends ConsumerStatefulWidget {
//   PersonalOnlineServiceLaw({super.key, required this.model});
//   PersonalOnlineServiceModel model;
//   @override
//   ConsumerState<PersonalOnlineServiceLaw> createState() => _PersonalOnlineServiceLawState();
// }
//
// class _PersonalOnlineServiceLawState extends ConsumerState<PersonalOnlineServiceLaw> {
//   PersonalOnlineServiceModel get model => widget.model;
//   late AppTheme _theme;
//
//   @override
//   Widget build(BuildContext context) {
//     _theme = ref.watch(userInfoProvider).theme ?? AppTheme(themeType: AppThemeType.original);
//     final AppColorTheme appColorTheme = _theme.getAppColorTheme;
//     final AppImageTheme appImageTheme = _theme.getAppImageTheme;
//     final List<String> list = model.lawList ?? [];
//     final double paddingHeight = UIDefine.getAppBarHeight() + UIDefine.getStatusBarHeight();
//     return MainScaffold(
//       padding: EdgeInsets.only(
//         top: paddingHeight, bottom: UIDefine.getNavigationBarHeight(),
//         left: WidgetValue.horizontalPadding, right: WidgetValue.horizontalPadding
//       ),
//       isFullScreen: true,
//       needSingleScroll: true,
//       // appBar: MainAppBar(title: model.title),
//       appBar: MainAppBar(
//         theme: _theme,
//         title: model.title,
//         backgroundColor: appColorTheme.appBarBackgroundColor,
//         leading: IconButton(
//           icon: ImgUtil.buildFromImgPath(appImageTheme.iconBack, size: 24.w),
//           onPressed: () => BaseViewModel.popPage(context),
//         ),
//       ),
//       backgroundColor: appColorTheme.appBarBackgroundColor,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
//         child: Column(
//           children: list.map((law) => Text(law)).toList(),
//         ),
//       )
//     );
//   }
// }