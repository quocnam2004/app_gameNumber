import 'package:app_game_number/src/pages/score/score_page.dart';
import 'package:app_game_number/src/utils/constants.dart';
import 'package:app_game_number/src/widgets/button_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.sw,
        height: 1.sh,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.background),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'NUMBER GAME',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                AppSpacing.large.verticalSpace,
                ButtonCustom(
                  name: 'START',
                  onTap: () {
                    Navigator.pushNamed(context, '/game');
                  },
                ),
                AppSpacing.medium.verticalSpace,
                ButtonCustom(
                  name: 'SCORE',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ScorePage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}