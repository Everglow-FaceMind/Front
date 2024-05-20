/// 측정 컨디션 정보를 담는 모델 클래스
class UserCondition {
  // 측정 날짜
  DateTime date;

  // 유저의 최대 심박수, 최소 심박수, 평균 심박수, 스트레스 레벨을 저장하는 변수
  final int maxHeartRate;
  final int minHeartRate;
  final int avgHeartRate;

  /// 스트레스 level 별 지수
  /// Lv1. 5~12
  /// Lv2. 12.1~19
  /// Lv3. 19.1~26
  /// Lv4. 26.1~33
  /// Lv5. 33.1~40
  final double stressLevel;

  UserCondition({
    required this.date,
    this.maxHeartRate = 0,
    this.minHeartRate = 0,
    this.avgHeartRate = 0,
    this.stressLevel = 0,
  });
}
