class HomeCalendarData {
  final String nickname;
  final List<CalendarResult> results;

  HomeCalendarData({required this.nickname, required this.results});

  factory HomeCalendarData.fromJson(Map<String, dynamic> json) {
    var resultList = (json['results'] as List<dynamic>)
        .map((item) => CalendarResult.fromJson(item))
        .toList();
    return HomeCalendarData(
      nickname: json['nickname'],
      results: resultList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'results': results.map((result) => result.toJson()).toList(),
    };
  }
}

class CalendarResult {
  final String date;
  final double stressRate;

  CalendarResult({required this.date, required this.stressRate});

  factory CalendarResult.fromJson(Map<String, dynamic> json) {
    return CalendarResult(
      date: json['date'],
      stressRate: json['stressRate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'stressRate': stressRate,
    };
  }

  String get emoji {
    if (33.1 <= stressRate && stressRate <= 40) {
      return '\u{1F621}';
    } else if (26.1 <= stressRate && stressRate <= 33) {
      return '\u{1F616}';
    } else if (19.1 <= stressRate && stressRate <= 26) {
      return '\u{1F614}';
    } else if (12.1 <= stressRate && stressRate <= 19) {
      return '\u{1F603}';
    } else {
      return '\u{1F606}';
    }
  }
//   Lv1. 5~12
// Lv2. 12.1~19
// Lv3. 19.1~26
// Lv4. 26.1~33
// Lv5. 33.1~40
}
