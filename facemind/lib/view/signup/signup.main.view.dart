import 'package:facemind/utils/global.colors.dart';
import 'package:facemind/view/widgets/agreement.dart';
import 'package:facemind/view/widgets/circles.in.signup.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

///페이지를 이렇게 네 개를 만드는 게 나은지, state를 쓰는 게 나은지
///
///
class SignupView extends StatelessWidget {
  const SignupView({Key? key});

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
          textAlign: TextAlign.left,
        ),
        backgroundColor: GlobalColors.whiteColor,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SignupCircle(
                      text: '1',
                      backgroundColor: GlobalColors.mainColor,
                      textColor: Colors.white),
                  SizedBox(width: 5),
                  SignupCircle(
                      text: '2',
                      backgroundColor: GlobalColors.lightlightgrayColor,
                      textColor: Colors.white),
                  SizedBox(width: 5),
                  SignupCircle(
                      text: '3',
                      backgroundColor: GlobalColors.lightlightgrayColor,
                      textColor: Colors.white),
                  SizedBox(width: 5),
                  SignupCircle(
                      text: '4',
                      backgroundColor: GlobalColors.lightlightgrayColor,
                      textColor: Colors.white),
                ],

                ///조건문으로 못바꿀까
              ),
              SizedBox(height: 20),
              Text(
                '페이스마인드에 오신 것을',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
              ),
              Text(
                '환영합니다!',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
              ),
              Expanded(
                child: Agreement(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
