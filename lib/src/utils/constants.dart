import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  static const Color primary = Color(0xff1FC5EA);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color red = Colors.red;
  static const Color splashColor = Color(0x661FC5EA);
}

class AppTextStyles {
  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle gameInfo = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: AppColors.white,
  );

  static const TextStyle dialogTitle = TextStyle(
    color: AppColors.black,
    fontSize: 20, // Giảm font size
    fontWeight: FontWeight.bold,
  );

  static const TextStyle dialogScoreLabel = TextStyle(
    color: AppColors.black,
    fontSize: 18, // Giảm font size
    fontWeight: FontWeight.bold,
  );

  static const TextStyle dialogScoreValue = TextStyle(
    color: AppColors.red,
    fontSize: 48, // Giảm font size
    fontWeight: FontWeight.bold,
  );
}

class AppSpacing {
  static const double small = 10;
  static const double medium = 15;
  static const double large = 20;
  static const double extraLarge = 25;
}

class AppBorderRadius {
  static final BorderRadius button = BorderRadius.circular(20.r);
  static final BorderRadius dialog = BorderRadius.circular(40.r);
}

class AppAssets {
  static const String background = 'assets/backgrounds/bg.png';
  static const String moneyIcon = 'assets/icons/money.png';
  static const String timeIcon = 'assets/icons/time.png';
  static const String rollIcon = 'assets/icons/roll.png';
}