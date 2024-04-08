import 'package:facemind/utils/global.colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:facemind/view/signup/signup.main.view.dart';
import 'package:facemind/view/widgets/button.global.dart';
import 'package:facemind/view/widgets/text.form.global.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.whiteColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    '(로고자리)페이스마인드',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                  width: 150,
                ),
                TextFormGlobal(
                  controller: emailController,
                  text: '이메일을 입력해 주세요.',
                  obscure: false,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                TextFormGlobal(
                  controller: passwordController,
                  text: '비밀번호를 입력해 주세요.',
                  textInputType: TextInputType.text,
                  obscure: true,
                ),
                const SizedBox(height: 30),
                ButtonGlobal(
                  text: '로그인',
                  buttonColor: GlobalColors.darkgrayColor,
                  onPressed: () {},
                ),
                Container(
                  height: 50,
                  color: GlobalColors.whiteColor,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '혹시 페이스마인드가 처음이시라면',
                        style: TextStyle(
                          color: GlobalColors.darkgrayColor,
                          fontSize: 11,
                        ),
                      ),
                      InkWell(
                        child: const Text(
                          ' 회원가입',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          Get.to(() => const SignupView());
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
