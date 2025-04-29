import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_game_number/src/utils/constants.dart';

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({
    super.key,
    required this.name,
    this.nameIcon = AppAssets.rollIcon,
    this.isShowIcon = false,
    required this.onTap,
    this.width = 214,
    this.height = 69,
  });

  final String name;
  final String nameIcon;
  final bool isShowIcon;
  final VoidCallback onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: AppBorderRadius.button,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: AppColors.splashColor,
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: AppBorderRadius.button,
          ),
          width: width.w,
          height: height.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isShowIcon) ...[
                Image.asset(nameIcon, width: 24.w),
                AppSpacing.medium.horizontalSpace,
              ],
              Text(
                name,
                style: AppTextStyles.button,
              ),
            ],
          ),
        ),
      ),
    );
  }
}