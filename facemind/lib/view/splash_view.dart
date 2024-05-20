import 'package:flutter/material.dart';
import 'package:facemind/utils/user_store.dart';
import 'package:facemind/view/home/home_view.dart';
import 'package:get/get.dart';
import 'package:facemind/view/login/login_view.dart';
import 'package:facemind/utils/global_colors.dart';

class AnimatedTextAppear extends StatefulWidget {
  final String text;
  final Duration duration;

  const AnimatedTextAppear({
    required this.text,
    required this.duration,
    super.key,
  });

  @override
  _AnimatedTextAppearState createState() => _AnimatedTextAppearState();
}

class _AnimatedTextAppearState extends State<AnimatedTextAppear>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _animation.value,
      child: Text(
        widget.text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.whiteColor,
      body: const Center(
        child: AnimatedTextAppear(
          text: 'FaceMind',
          duration: Duration(seconds: 2),
        ),
      ),
    );
  }

  Future<void> _checkUserInfo() async {
    await UserStore.to.loadUserInfo();
    await Future.delayed(const Duration(seconds: 2));

    if (UserStore.to.currentUser != null) {
      Get.off(() => const HomeView());
    } else {
      Get.off(() => const LoginView());
    }
  }
}
