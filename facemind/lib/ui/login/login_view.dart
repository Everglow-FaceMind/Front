import 'package:facemind/api/api_client.dart';
import 'package:facemind/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:facemind/ui/signup/signup_view.dart';
import 'package:facemind/ui/common/widgets/button_global.dart';
import '../../utils/string_extension.dart';
import '../../utils/user_store.dart';
import '../home/home_view.dart';
import '../common/widgets/login_text_form.dart';

class Assets {
  static String logo2 = 'assets/Images/logo2.png';
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                Image.asset(
                  width: 150,
                  Assets.logo2,
                ),
                const SizedBox(height: 30),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    '페이스마인드',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                  width: 150,
                ),
                LoginTextFrom(
                  controller: _emailController,
                  hintText: '이메일을 입력해 주세요.',
                  textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null) return null;
                    final text = value.toString();
                    return text.emailValidat;
                  },
                  onChanged: (p0) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20),
                LoginTextFrom(
                  controller: _passwordController,
                  hintText: '비밀번호를 입력해 주세요.',
                  validator: (value) {
                    if (value == null) return null;
                    final text = value.toString();
                    return text.passwordValidat;
                  },
                  onChanged: (p0) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 30),
                ButtonGlobal(
                  text: '로그인',
                  buttonColor: _isInputValid
                      ? GlobalColors.mainColor
                      : GlobalColors.darkgrayColor,
                  onPressed: _isInputValid ? _login : null,
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
                      const SizedBox(width: 4),
                      InkWell(
                        child: const Text(
                          '회원가입',
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

  /// 로그인 동작
  Future<void> _login() async {
    final result = await ApiClient.to
        .login(_emailController.text, _passwordController.text);
    if (result == null) {
      Get.snackbar('로그인 실패', '로그인에 실패 하였습니다.');
      return;
    }
    UserStore.to.updateUser(result);
    Get.off(() => const HomeView());
  }

  /// 입력한 이메일과 비밀번호가 유효한지 확인
  bool get _isInputValid =>
      _emailController.text.emailValidat == null &&
      _passwordController.text.passwordValidat == null;
}
