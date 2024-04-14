import 'package:facemind/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:facemind/view/signup/signup_view.dart';
import 'package:facemind/widgets/button_global.dart';

import '../../utils/string_extension.dart';
import '../home/home_view.dart';
import '../../widgets/login_text_form.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                LoginTextFrom(
                  controller: emailController,
                  hintText: '이메일을 입력해 주세요.',
                  textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null) return null;
                    final text = value.toString();
                    return text.emailValidat;
                  },
                ),
                const SizedBox(height: 20),
                LoginTextFrom(
                  controller: passwordController,
                  hintText: '비밀번호를 입력해 주세요.',
                  validator: (value) {
                    if (value == null) return null;
                    final text = value.toString();
                    return text.passwordValidat;
                  },
                ),
                const SizedBox(height: 30),
                ButtonGlobal(
                  text: '로그인',
                  buttonColor: GlobalColors.darkgrayColor,
                  onPressed: () {
                    if (passwordController.text == '1234') {
                      Get.offAll(() => const HomeView());
                    } else {
                      Get.snackbar(
                        '로그인 실패',
                        '비밀번호가 틀렸습니다.',
                        backgroundColor: GlobalColors.darkgrayColor,
                        colorText: GlobalColors.whiteColor,
                      );
                    }
                  },
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

class ExampleView extends StatefulWidget {
  final String text;
  const ExampleView({
    super.key,
    required this.text,
  });
  @override
  State<StatefulWidget> createState() => _ExampleViewState();
}

class _ExampleViewState extends State<ExampleView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.text),
    );
  }
}
