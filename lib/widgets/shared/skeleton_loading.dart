

import 'package:flutter/material.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoading extends StatelessWidget {

  const SkeletonLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.mainGrey.withOpacity(0.3),
      highlightColor: AppColors.mainLightGrey.withOpacity(0.3),
      period: const Duration(milliseconds: 1100),
      child: Container(
        color: AppColors.mainGrey
      ),
    );
  }
}