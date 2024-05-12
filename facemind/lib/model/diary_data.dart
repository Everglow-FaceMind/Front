import 'package:facemind/model/user_condition.dart';

class DiaryData {
  final UserCondition userCondition;
  final List<String> emotions;
  final List<String> reasons;
  final String content;
  final DateTime date;

  DiaryData({
    required this.userCondition,
    required this.emotions,
    required this.reasons,
    required this.content,
    required this.date,
  });
}
