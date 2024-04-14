import 'package:flutter/material.dart';

import '../utils/global_colors.dart';

class LoginTextFrom extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final String? hintText;
  final FormFieldValidator? validator;
  final int? maxLength;
  final Function(String)? onChanged;

  const LoginTextFrom({
    super.key,
    required this.controller,
    this.textInputType = TextInputType.text,
    this.hintText,
    this.validator,
    this.maxLength,
    this.onChanged,
  });

  @override
  State<LoginTextFrom> createState() => _LoginTextFromState();
}

class _LoginTextFromState extends State<LoginTextFrom> {
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
        controller: widget.controller,
        keyboardType: widget.textInputType,
        validator: widget.validator,
        maxLength: widget.maxLength,
        onChanged: (value) {
          widget.onChanged?.call(value);
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(right: 10),
          hintStyle: const TextStyle(
            height: 1,
          ),
          suffixText: widget.maxLength == null ? null : _maxSuffixText,
          suffixStyle: TextStyle(
            fontSize: 14,
            color: GlobalColors.lightgrayColor,
          ),
          counterText: '',
        ),
      ),
    );
  }

  String get _maxSuffixText =>
      '${widget.controller.text.length.toString()}/${widget.maxLength.toString()}';
}
