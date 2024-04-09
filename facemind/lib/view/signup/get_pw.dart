import 'package:facemind/utils/global.colors.dart';
import 'package:facemind/view/signup/get_profile.dart';
import 'package:facemind/view/widgets/button.global.dart';
import 'package:facemind/view/widgets/circles.in.signup.dart';
import 'package:facemind/view/widgets/text.form.global.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class GetPassword extends StatelessWidget {
  GetPassword({super.key});

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
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
                        backgroundColor: GlobalColors.mainColor,
                        textColor: Colors.white),
                    SizedBox(width: 5),
                    SignupCircle(
                        text: '3',
                        backgroundColor: GlobalColors.mainColor,
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
                const Text(
                  '사용하실 비밀번호를',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '입력해주세요.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),

                ///입력폼
                const Text(
                  '비밀번호',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormGlobal(
                  controller: passwordController,
                  text: '비밀번호를 입력해 주세요.',
                  textInputType: TextInputType.visiblePassword,
                  obscure: true,
                ),
                const SizedBox(height: 25),

                ///비밀번호 재확인
                const Text(
                  '비밀번호 확인',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormGlobal(
                  controller: passwordController,
                  text: '비밀번호를 한번 더 입력해 주세요.',
                  textInputType: TextInputType.visiblePassword,
                  obscure: true,
                ),
                const SizedBox(height: 50),

                ButtonGlobal(
                  text: '다음',
                  onPressed: () {
                    String password = passwordController.text; //이메일 유효성 검사??
                    Get.to(GetProfile());
                  },
                  buttonColor: GlobalColors.darkgrayColor,
                ),
              ],
            )),
      ),
    );
  }
}
