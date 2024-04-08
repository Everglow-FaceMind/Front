import 'package:facemind/utils/global.colors.dart';
import 'package:facemind/view/widgets/agreement.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class SignupView extends StatelessWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.chevron_left, size: 20),
          color: GlobalColors.darkgrayColor,
        ),
        title: Text(
          '회원가입',
          style: TextStyle(
              color: GlobalColors.darkgrayColor,
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
        backgroundColor: GlobalColors.whiteColor,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(35.0),
          child: Column(
            children: [
              Expanded(
                child: Agreement(), // MyApp 위젯을 SignupView 내에서 사용
              ),
            ],
          ),
        ),
      ),
    );
  }
}
