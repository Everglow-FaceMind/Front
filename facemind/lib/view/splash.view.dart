import 'dart:async';

import 'package:get/get.dart';
import 'package:facemind/view/login.view.dart';
import 'package:flutter/material.dart';
import 'package:facemind/utils/global.colors.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Get.to(LoginView());
    });
    return Scaffold(
        backgroundColor: GlobalColors.mainColor,
        body: const Center(
            child: Text('FaceMind',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ))));
  }
}
