/// 측정 컨디션 정보를 담는 모델 클래스(임시)
class UserCondition {
  // 측정 날짜
  DateTime date;

  // 유저의 최대 심박수, 최소 심박수, 평균 심박수, 스트레스 레벨을 저장하는 변수
  final int maxHeartRate;
  final int minHeartRate;
  final int avgHeartRate;
  final int stressLevel; // Min: 0, Max: 100??

  UserCondition({
    required this.date,
    this.maxHeartRate = 0,
    this.minHeartRate = 0,
    this.avgHeartRate = 0,
    this.stressLevel = 0,
  });

  /// 스트레스 레벨에 따라 이모지를 반환하는 함수
  String get emoji {
    if (stressLevel < 20) {
      return '\u{1F606}';
    } else if (stressLevel < 40) {
      return '\u{1F603}';
    } else if (stressLevel < 60) {
      return '\u{1F614}';
    } else if (stressLevel < 80) {
      return '\u{1F616}';
    } else {
      return '\u{1F621}';
    }
  }
}
