import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stoxplay/utils/common/widgets/app_button.dart';
import 'package:stoxplay/utils/common/widgets/common_stoxplay_icon.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:stoxplay/utils/constants/app_routes.dart';
import 'package:stoxplay/utils/constants/app_strings.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _leftImageAnimation;
  late Animation<double> _rightImageAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _textMoveAnimation;
  late Animation<double> _iconShadowOpacityAnimation;
  late Animation<double> _buttonShowOpacityAnimation;
  late Animation<Offset> _strokesImageAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    Future.delayed(const Duration(milliseconds: 200), () {
      _controller.forward();
    });
  }

  void _setupAnimations() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300));

    _leftImageAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: -100).chain(CurveTween(curve: Curves.easeOutQuart)),
        weight: 60.w,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -100, end: 0).chain(CurveTween(curve: Curves.easeInOutQuart)),
        weight: 40.w,
      ),
    ]).animate(_controller);

    _rightImageAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 100).chain(CurveTween(curve: Curves.easeOutQuart)),
        weight: 60.w,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 100, end: 0).chain(CurveTween(curve: Curves.easeInOutQuart)),
        weight: 40.w,
      ),
    ]).animate(_controller);

    _textOpacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.1, 0.5, curve: Curves.easeInOut)));

    _textMoveAnimation = Tween<double>(
      begin: 0,
      end: 100,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.5, 0.8, curve: Curves.easeOutCubic)));

    _iconShadowOpacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.5, 0.8, curve: Curves.easeInOut)));

    _buttonShowOpacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.6, 0.9, curve: Curves.easeInOut)));

    _strokesImageAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: const Offset(0.0, -0.5),
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.1, 0.4, curve: Curves.easeOutCubic)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                SlideTransition(
                  position: _strokesImageAnimation,
                  child: Image.asset(
                    AppAssets.splashStrokes,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Transform.translate(
                  offset: Offset(_leftImageAnimation.value - 15.w, 0),
                  child: Image.asset(AppAssets.leftSIcon, width: 60.w, height: 60.h),
                ),
                Transform.translate(
                  offset: Offset(_rightImageAnimation.value + 5.w, 35.h),
                  child: Image.asset(AppAssets.rightSIcon, width: 60.w, height: 60.h),
                ),
                Opacity(
                  opacity: _iconShadowOpacityAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, 80.h),
                    child: Image.asset(AppAssets.iconShadow, width: 120.w),
                  ),
                ),
                Opacity(
                  opacity: _textOpacityAnimation.value,
                  child: Padding(
                    padding: EdgeInsets.only(top: 350.h),
                    child: TextView(
                      text: 'Let’s Play    |     Let’s Learn    |    Let’s Stoxplay',
                      fontSize: 17.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                      fontColor: AppColors.blue3200,
                    ),
                  ),
                ),

                Transform.translate(
                  offset: Offset(0, _textMoveAnimation.value.w + 20.h),
                  child: Opacity(opacity: _textOpacityAnimation.value, child: CommonStoxplayText()),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _buttonShowOpacityAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _buttonShowOpacityAnimation.value,
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: AppButton(
                text: Strings.getStarted,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.loginPage);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
