import 'package:app_game_number/src/pages/providers/game_provider.dart';
import 'package:app_game_number/src/utils/constants.dart';
import 'package:app_game_number/src/widgets/button_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({super.key});

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
              children: [
                AppSpacing.large.verticalSpace,
                Text(
                  'Leaderboard',
                  style: AppTextStyles.dialogTitle.copyWith(
                    color: AppColors.white,
                    fontSize: 24.sp,
                  ),
                ),
                AppSpacing.large.verticalSpace,
                Expanded(
                  child: Consumer<GameProvider>(
                    builder: (context, provider, child) {
                      if (provider.playerScores.isEmpty) {
                        return Center(
                          child: Text(
                            'No scores yet!',
                            style: AppTextStyles.gameInfo.copyWith(
                              fontSize: 18.sp,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: provider.playerScores.length,
                        itemBuilder: (context, index) {
                          final playerScore = provider.playerScores[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  playerScore.name,
                                  style: AppTextStyles.gameInfo.copyWith(
                                    fontSize: 16.sp,
                                  ),
                                ),
                                Text(
                                  playerScore.score.toString(),
                                  style: AppTextStyles.gameInfo.copyWith(
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                AppSpacing.large.verticalSpace,
                ButtonCustom(
                  name: 'Clear Scores',
                  width: 200.w,
                  height: 50.h,
                  onTap: () {
                    Provider.of<GameProvider>(context, listen: false).clearScores();
                  },
                ),
                AppSpacing.medium.verticalSpace,
                ButtonCustom(
                  name: 'Back',
                  width: 200.w,
                  height: 50.h,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                AppSpacing.large.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}