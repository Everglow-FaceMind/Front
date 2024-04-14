import 'package:facemind/utils/global_colors.dart';
import 'package:flutter/material.dart';

class TextFormGlobal extends StatefulWidget {
  // required: 반드시 값이 필요한 파라미터
  const TextFormGlobal({
    Key? key,
    required this.controller,
    required this.text,
    required this.textInputType,
    required this.obscure,
    this.validate = false,
    required Null Function(dynamic value) onChanged,
  }) // validate 옵션 추가
  : super(key: key);
  final TextEditingController controller;
  final String text;
  final TextInputType textInputType;
  final bool obscure;
  final bool validate;

  String? _validateEmail(String? value) {
    if (!validate) return null;
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요.';
    }
    // 이메일 형식을 확인하는 정규식
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return '올바른 이메일 주소를 입력해주세요.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.only(top: 2, left: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1,
          color: GlobalColors.lightgrayColor,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: textInputType,
        obscureText: obscure,
        validator: _validateEmail, // 이메일 유효성 검사 함수
        decoration: InputDecoration(
            hintText: text,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(0),
            hintStyle: const TextStyle(
              height: 1,
            )),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
