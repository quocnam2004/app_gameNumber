import 'dart:async';
import 'package:app_game_number/src/pages/providers/game_provider.dart';
import 'package:app_game_number/src/pages/score/score_page.dart'; // Import ScorePage
import 'package:app_game_number/src/utils/constants.dart';
import 'package:app_game_number/src/widgets/button_custom.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  Timer? _timer;
  bool _hasShownGameOverDialog = false;

  @override
  void initState() {
    super.initState();
    _hasShownGameOverDialog = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<GameProvider>(context, listen: false);
      debugPrint('Initializing GamePage...');
      provider.resetGame();
      _startTimer();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final provider = Provider.of<GameProvider>(context, listen: false);
      if (!provider.isGameOver) {
        provider.decrementTime();
        debugPrint('Timer tick: timeLeft=${provider.timeLeft}, isGameOver=${provider.isGameOver}');
        if (provider.timeLeft == 0 && !_hasShownGameOverDialog) {
          _hasShownGameOverDialog = true;
          _showGameOverDialog(provider.score, false);
          debugPrint('Timer triggered game over dialog.');
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showGameOverDialog(int score, bool isWin) {
    debugPrint('Showing game over dialog: score=$score, isWin=$isWin');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => GameOverDialog(
        score: score,
        isWin: isWin,
        onSave: (name) {
          Provider.of<GameProvider>(context, listen: false).savePlayerScore(name);
          Navigator.of(context).pop();
          _hasShownGameOverDialog = false;
        },
        onTryAgain: () {
          Provider.of<GameProvider>(context, listen: false).resetGame();
          _hasShownGameOverDialog = false;
          _startTimer();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        final listData = provider.listNumber;
        debugPrint('Building GamePage: nextNumber=${provider.nextNumber}, isGameOver=${provider.isGameOver}');

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
                    Row(
                      children: [
                        Image.asset(AppAssets.moneyIcon, width: 24.w),
                        AppSpacing.small.horizontalSpace,
                        Text(
                          provider.score.toString(),
                          style: AppTextStyles.gameInfo,
                        ),
                        const Spacer(),
                        Image.asset(AppAssets.timeIcon, width: 24.w),
                        AppSpacing.small.horizontalSpace,
                        Text(
                          provider.formattedTime,
                          style: AppTextStyles.gameInfo,
                        ),
                      ],
                    ),
                    AppSpacing.medium.verticalSpace,
                    ButtonCustom(
                      name: 'View Scores',
                      width: 150.w,
                      height: 40.h,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ScorePage()),
                        );
                      },
                    ),
                    AppSpacing.extraLarge.verticalSpace,
                    Expanded(
                      child: GridView.builder(
                        physics: const ClampingScrollPhysics(),
                        cacheExtent: 1000,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: AppSpacing.large,
                          crossAxisSpacing: 22,
                        ),
                        itemCount: listData.length,
                        itemBuilder: (context, index) {
                          final number = listData[index];
                          final isSelected = provider.selectedNumbers.contains(number);

                          return _NumberTile(
                            number: number,
                            isSelected: isSelected,
                            isGameOver: provider.isGameOver,
                            onTap: (isCorrect) {
                              debugPrint('Number $number tapped, isCorrect: $isCorrect, isGameOver: ${provider.isGameOver}');
                              if (!isCorrect && !_hasShownGameOverDialog) {
                                _hasShownGameOverDialog = true;
                                _showGameOverDialog(provider.score, false);
                              } else if (provider.nextNumber > 50 && !_hasShownGameOverDialog) {
                                _hasShownGameOverDialog = true;
                                _showGameOverDialog(provider.score, true);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NumberTile extends StatefulWidget {
  final int number;
  final bool isSelected;
  final bool isGameOver;
  final Function(bool) onTap;

  const _NumberTile({
    required this.number,
    required this.isSelected,
    required this.isGameOver,
    required this.onTap,
  });

  @override
  State<_NumberTile> createState() => _NumberTileState();
}

class _NumberTileState extends State<_NumberTile> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: widget.isSelected ? Colors.transparent : AppColors.white,
        onTap: widget.isSelected || widget.isGameOver
            ? null
            : () {
                final provider = Provider.of<GameProvider>(context, listen: false);
                final isCorrect = provider.tapNumber(widget.number);
                if (isCorrect) {
                  _controller.forward().then((_) => _controller.reverse());
                }
                widget.onTap(isCorrect);
              },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Ink(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isSelected
                  ? Colors.grey.withOpacity(0.5)
                  : Colors.primaries[widget.number % Colors.primaries.length],
            ),
            child: Center(
              child: Text(
                '${widget.number}',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: widget.isSelected ? Colors.white.withOpacity(0.5) : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GameOverDialog extends StatelessWidget {
  final int score;
  final bool isWin;
  final Function(String) onSave;
  final VoidCallback onTryAgain;

  const GameOverDialog({
    super.key,
    required this.score,
    required this.isWin,
    required this.onSave,
    required this.onTryAgain,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.dialog,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: AppSpacing.large),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 300.w,
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                isWin ? 'Congratulations!' : 'Sorry, you failed',
                style: AppTextStyles.dialogTitle,
                textAlign: TextAlign.center,
              ),
              AppSpacing.large.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Your score: ',
                    style: AppTextStyles.dialogScoreLabel,
                  ),
                  Text(
                    score.toString(),
                    style: AppTextStyles.dialogScoreValue,
                  ),
                ],
              ),
              AppSpacing.medium.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Name: ',
                    style: AppTextStyles.dialogScoreLabel,
                  ),
                  SizedBox(
                    width: 120.w,
                    child: TextField(
                      controller: nameController,
                      autofocus: true,
                      maxLength: 20,
                      decoration: InputDecoration(
                        hintText: 'Your name',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                        border: const UnderlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 8.w,
                        ),
                        counterText: '',
                      ),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              AppSpacing.medium.verticalSpace,
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10.w,
                runSpacing: 10.h,
                children: [
                  ButtonCustom(
                    name: 'SAVE',
                    width: 120.w,
                    height: 50.h,
                    onTap: () {
                      onSave(nameController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Score saved!')),
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                  ButtonCustom(
                    name: 'Try Again',
                    width: 120.w,
                    height: 50.h,
                    onTap: () {
                      onTryAgain();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}