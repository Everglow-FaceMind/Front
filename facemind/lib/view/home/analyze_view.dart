import 'package:flutter/cupertino.dart';

class AnalyzeView extends StatefulWidget {
  const AnalyzeView({super.key});
  @override
  State<AnalyzeView> createState() => _AnalyzeViewState();
}

class _AnalyzeViewState extends State<AnalyzeView> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('통계 페이지'),
    );
  }
}
