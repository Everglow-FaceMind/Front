import 'package:flutter/cupertino.dart';

class MyPageView extends StatefulWidget {
  const MyPageView({super.key});
  @override
  State<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('마이 페이지'),
    );
  }
}