class JournalDetails {
  final int? journalId;
  final String? date;
  final String? dayOfTheWeek;
  final String? time;
  final int? heartRateMin;
  final int? heartRateMax;
  final int? heartRateAvg;
  final int? stressLevel;
  final List<String>? emotion;
  final List<String>? cause;
  final String? note;

  JournalDetails({
    this.journalId,
    this.date,
    this.dayOfTheWeek,
    this.time,
    this.heartRateMin,
    this.heartRateMax,
    this.heartRateAvg,
    this.stressLevel,
    this.emotion,
    this.cause,
    this.note,
  });

  factory JournalDetails.fromJson(Map<String, dynamic> json) {
    return JournalDetails(
      journalId: json['journalId'],
      date: json['date'],
      dayOfTheWeek: json['dayOfTheWeek'],
      time: json['time'],
      heartRateMin: json['heartRateMin'],
      heartRateMax: json['heartRateMax'],
      heartRateAvg: json['heartRateAvg'],
      stressLevel: json['stressLevel'],
      emotion:
          json['emotion'] != null ? List<String>.from(json['emotion']) : null,
      cause: json['cause'] != null ? List<String>.from(json['cause']) : null,
      note: json['note'],
    );
  }
}
