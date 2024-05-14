import 'dart:async';

import 'package:facemind/utils/user_store.dart';
import 'package:facemind/view/home/home_view.dart';
import 'package:get/get.dart';
import 'package:facemind/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:facemind/utils/global_colors.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
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
        child: Text(
          'FaceMind',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
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
