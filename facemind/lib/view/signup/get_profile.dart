import 'package:facemind/utils/global.colors.dart';
import 'package:facemind/view/widgets/button.global.dart';
import 'package:facemind/view/widgets/circles.in.signup.dart';
import 'package:facemind/view/widgets/text.form.global.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class GetProfile extends StatelessWidget {
  GetProfile({super.key});

  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

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
                        backgroundColor: GlobalColors.mainColor,
                        textColor: Colors.white),
                  ],

                  ///조건문으로 못바꿀까
                ),
                SizedBox(height: 20),
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
                TextFormGlobal(
                  controller: nicknameController,
                  text: '닉네임을 입력해 주세요.',
                  textInputType: TextInputType.text,
                  obscure: false,
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
                TextFormGlobal(
                  controller: bioController,
                  text: '한줄소개를 입력해 주세요.',
                  textInputType: TextInputType.text,
                  obscure: false,
                ),
                const SizedBox(height: 50),

                ButtonGlobal(
                  text: '가입 완료',
                  onPressed: () {
                    String nickname = nicknameController.text;
                    String bio = bioController.text;
                  },
                  buttonColor: GlobalColors.darkgrayColor,
                ),
              ],
            )),
      ),
    );
  }
}
