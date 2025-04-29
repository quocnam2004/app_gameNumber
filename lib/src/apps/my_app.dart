import 'package:app_game_number/src/pages/game/game_page.dart';
import 'package:app_game_number/src/pages/home/home_page.dart';
import 'package:app_game_number/src/pages/providers/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:app_game_number/src/utils/constants.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: ScreenUtilInit(
        designSize: const Size(414, 896),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Game Number',
          theme: ThemeData(
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: Colors.transparent,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                textStyle: AppTextStyles.button,
                shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.button,
                ),
              ),
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (_) => const HomePage(),
            '/game': (_) => const GamePage(),
          },
        ),
      ),
    );
  }
}