import 'package:facemind/utils/global.colors.dart';
import 'package:facemind/view/signup/get_pw.dart';
import 'package:facemind/view/widgets/button.global.dart';
import 'package:facemind/view/widgets/text.form.global.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class GetEmail extends StatelessWidget {
  GetEmail({super.key});

  final TextEditingController emailController = TextEditingController();

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
                TextFormGlobal(
                  controller: emailController,
                  text: '이메일 주소를 입력해 주세요.',
                  textInputType: TextInputType.emailAddress,
                  obscure: false,
                ),
                const SizedBox(height: 50),
                ButtonGlobal(
                  text: '다음',
                  onPressed: () {
                    String email = emailController.text; //이메일 유효성 검사??
                    Get.to(() => GetPassword());
                  },
                  buttonColor: GlobalColors.darkgrayColor,
                ),
              ],
            )),
      ),
    );
  }
}
