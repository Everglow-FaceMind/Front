class StatisticsData {
  final String date;
  final String dayOfTheWeek;
  final List<HeartRateDetail> heartRate;
  final List<StressLevelDetail> stressLevel;

  StatisticsData({
    required this.date,
    required this.dayOfTheWeek,
    required this.heartRate,
    required this.stressLevel,
  });

  factory StatisticsData.fromJson(Map<String, dynamic> json) {
    return StatisticsData(
      date: json['date'],
      dayOfTheWeek: json['dayOfTheWeek'],
      heartRate: (json['heartRate'] as List<dynamic>)
          .map((i) => HeartRateDetail.fromJson(i))
          .toList(),
      stressLevel: (json['stressLevel'] as List<dynamic>)
          .map((i) => StressLevelDetail.fromJson(i))
          .toList(),
    );
  }
}

class HeartRateDetail {
  final String date;
  final String dayOfTheWeek;
  final int heartRateMax;
  final int heartRateMin;

  HeartRateDetail({
    required this.date,
    required this.dayOfTheWeek,
    required this.heartRateMax,
    required this.heartRateMin,
  });

  factory HeartRateDetail.fromJson(Map<String, dynamic> json) {
    return HeartRateDetail(
      date: json['date'],
      dayOfTheWeek: json['dayOfTheWeek'],
      heartRateMax: json['heartRateMax'],
      heartRateMin: json['heartRateMin'],
    );
  }
}

class StressLevelDetail {
  final int level;
  final int percentage;

  StressLevelDetail({
    required this.level,
    required this.percentage,
  });

  factory StressLevelDetail.fromJson(Map<String, dynamic> json) {
    return StressLevelDetail(
      level: json['level'],
      percentage: json['percentage'],
    );
  }
}
