import 'package:facemind/api/api_client.dart';
import 'package:facemind/api/model/user_info.dart';
import 'package:facemind/model/user.dart';
import 'package:facemind/utils/global_colors.dart';
import 'package:facemind/utils/string_extension.dart';
import 'package:facemind/utils/user_store.dart';
import 'package:facemind/ui/common/widgets/agreement.dart';
import 'package:facemind/ui/common/widgets/circles_in_signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/home_view.dart';
import '../common/widgets/button_global.dart';
import '../common/widgets/login_text_form.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final UserStore _userStore = Get.find();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  final PageController _pageController = PageController(initialPage: 0);

  int _tabIndex = 0;

  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _nickname = '';
  String _bioName = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nicknameController.dispose();
    _bioController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: _back,
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
              _pageNumberView(),
              const SizedBox(height: 20),
              Expanded(
                child: PageView(
                  onPageChanged: (index) {
                    setState(() {
                      _tabIndex = index;
                    });
                  },
                  controller: _pageController,
                  children: [
                    _agreementView(),
                    _emailView(),
                    _passwordView(),
                    _nicknameView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pageNumberView() {
    return Row(
      children: List.generate(
        4,
        (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: SignupCircle(
              text: (index + 1).toString(),
              backgroundColor: _tabIndex == index
                  ? GlobalColors.mainColor
                  : GlobalColors.lightlightgrayColor,
              textColor: Colors.white,
            ),
          );
        },
      ),
    );
  }

  /// 권한 동의 화면
  Widget _agreementView() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            '페이스마인드에 오신 것을',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
          ),
          const Text(
            '환영합니다!',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
          ),
          Expanded(
            child: Agreement(
              onNext: () {
                _pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 이메일 입력 화면
  Widget _emailView() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            '이메일을 입력해주세요.',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 50),
          LoginTextFrom(
            controller: _emailController,
            hintText: '이메일을 입력해 주세요.',
            textInputType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null) return null;
              final text = value.toString();
              return text.emailValidat;
            },
            onChanged: (value) {
              setState(() {
                _email = value.toString();
              });
            },
          ),
          const SizedBox(height: 50),
          ButtonGlobal(
            text: '다음',
            onPressed: () {
              if (_emailController.text.emailValidat == null) {
                _pageController.animateToPage(
                  2,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              } else {
                Get.snackbar('이메일 입력', '이메일 형식에 맞게 입력해주세요.');
              }
            },
            buttonColor: _email.isNotEmpty && _email.emailValidat == null
                ? GlobalColors.mainColor
                : GlobalColors.darkgrayColor,
          ),
        ],
      ),
    );
  }

  /// 비밀번호 입력 화면
  Widget _passwordView() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

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
          LoginTextFrom(
            controller: _passwordController,
            hintText: '비밀번호를 입력해 주세요.',
            textInputType: TextInputType.visiblePassword,
            validator: (value) {
              if (value == null) return null;
              final text = value.toString();
              return text.passwordValidat;
            },
            onChanged: (value) {
              setState(() {
                _password = value.toString();
              });
            },
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
          LoginTextFrom(
            controller: _confirmPasswordController,
            hintText: '비밀번호를 한번 더 입력해 주세요.',
            textInputType: TextInputType.visiblePassword,
            validator: (value) {
              if (value == null) return null;
              final text = value.toString();
              return text.passwordValidat;
            },
            onChanged: (value) {
              setState(() {
                _confirmPassword = value.toString();
              });
            },
          ),
          const SizedBox(height: 50),
          ButtonGlobal(
            text: '다음',
            onPressed: () {
              final isSame =
                  _passwordController.text == _confirmPasswordController.text;
              if (isSame) {
                _pageController.animateToPage(
                  3,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              } else {
                Get.snackbar('비밀번호 확인', '비밀번호가 일치하지 않습니다.');
              }
            },
            buttonColor: _password == _confirmPassword && _password.isNotEmpty
                ? GlobalColors.mainColor
                : GlobalColors.darkgrayColor,
          ),
        ],
      ),
    );
  }

  /// 닉네임 입력 화면
  Widget _nicknameView() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            '프로필을 설정해주세요.',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 50),

          ///닉네임 입력폼
          const Text(
            '닉네임',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          LoginTextFrom(
            controller: _nicknameController,
            hintText: '닉네임을 입력해 주세요.',
            textInputType: TextInputType.text,
            maxLength: 10,
            validator: (value) {
              if (value == null) return null;
              final text = value.toString();
              return text.trim().isEmpty ? '닉네임을 입력해주세요.' : null;
            },
            onChanged: (value) {
              setState(() {
                _nickname = value.toString();
              });
            },
          ),
          const SizedBox(height: 25),

          ///한 줄 소개 입력
          const Text(
            '한줄소개',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          LoginTextFrom(
            controller: _bioController,
            hintText: '한줄소개를 입력해 주세요.',
            textInputType: TextInputType.text,
            maxLength: 50,
            onChanged: (value) {
              setState(() {
                _bioName = value.toString();
              });
            },
          ),
          const SizedBox(height: 50),
          ButtonGlobal(
            text: '가입 완료',
            onPressed: () {
              // 회원가입 구현
              if (_nicknameController.text.trim().isEmpty) {
                Get.snackbar('닉네임 입력', '닉네임을 입력해주세요');
                return;
              } else {
                signUp();
              }
            },
            buttonColor: _nickname.trim().isNotEmpty
                ? GlobalColors.mainColor
                : GlobalColors.darkgrayColor,
          ),
        ],
      ),
    );
  }

  Future<void> signUp() async {
    final result = await ApiClient.to.signUp(
      email: _emailController.text,
      password: _passwordController.text,
      nickname: _nicknameController.text,
      alarmAllowance: false,
      introduction: _bioController.text,
    );

    if (!result) {
      Get.snackbar('회원가입 실패', '회원가입에 실패했습니다.');
    } else {
      final userInfo = await ApiClient.to
          .login(_emailController.text, _passwordController.text);
      if (userInfo != null) {
        _userStore.updateUser(UserInfo(
          email: _emailController.text,
          nickname: _nicknameController.text,
          introduction: _bioController.text,
          token: userInfo.token,
        ));
        Get.offAll(() => const HomeView());
      } else {
        Get.snackbar('로그인 실패', '로그인 페이지에서 로그인을 시도 해주세요.');
      }
    }
  }

  /// 뒤로가기
  void _back() {
    // 페이지가 0보다 크면 이전 페이지로 이동
    if (_tabIndex > 0) {
      _pageController.animateToPage(
        _tabIndex - 1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    } else {
      Get.back();
    }
  }
}
