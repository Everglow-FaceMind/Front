import 'package:facemind/utils/global.colors.dart';
import 'package:facemind/view/widgets/agreement.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

///이렇게 하는 게 아닌 것 같음!!
///코드가 더러움
///바디 안에 있는 것만 바꾸면 될 것 같은데
///페이지 넘버,

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.chevron_left, size: 20),
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
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                '페이스마인드에 오신 것을',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Text(
                '환영합니다.',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
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
