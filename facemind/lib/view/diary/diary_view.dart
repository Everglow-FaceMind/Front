import 'dart:math';

import 'package:facemind/utils/global_colors.dart';
import 'package:facemind/view/home/analyze_view.dart';
import 'package:facemind/view/home/calendar_view.dart';
import 'package:facemind/view/home/my_page_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/diary_data.dart';
import '../../model/user_condition.dart';

class DiaryView extends StatefulWidget {
  final DateTime date;

  const DiaryView({
    super.key,
    required this.date,
  });

  @override
  State<DiaryView> createState() => _DiaryViewState();
}

class _DiaryViewState extends State<DiaryView> {
  List<DiaryData> diaryList = [];
  DateTime date = DateTime.now();
  bool isExpanded = false; //note 내용 50자 이상 시 확장
  @override
  void initState() {
    date = widget.date;
    fetchDiaryData(date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        backgroundColor: GlobalColors.whiteColor,
        body: Container(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 15),
                child: const Text(
                  '내 일기',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Divider(
                height: 10.0,
                color: Colors.grey[300],
                thickness: 1,
              ),
              const SizedBox(height: 10),
              _displayDate,
              Expanded(
                child: ListView.builder(
                  itemCount: diaryList.length,
                  itemBuilder: (context, index) {
                    final diary = diaryList[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: GlobalColors.subBgColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                diary.userCondition.emoji,
                                style: TextStyle(
                                  fontSize: 40,
                                  color: GlobalColors.darkgrayColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    diary.emotions.join(", "),
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('HH:mm').format(diary.date),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // 수정 기능 구현
                                    },
                                    child: const Text(
                                      "수정",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xffF59A2F)),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 12,
                                      width: 0.5,
                                      color: GlobalColors.darkgrayColor,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  InkWell(
                                    onTap: () {
                                      // 삭제 기능 구현
                                    },
                                    child: Text(
                                      "삭제",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: GlobalColors.darkgreenColor),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                '느낀 감정',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: GlobalColors.darkgrayColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                diary.emotions.join(","),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '감정의 원인',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: GlobalColors.darkgrayColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                diary.reasons.join(", "),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Text(
                                'Note',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  isExpanded || diary.content.length <= 50
                                      ? diary.content
                                      : diary.content.substring(0, 50),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: GlobalColors.darkgrayColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (diary.content.length > 50)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isExpanded = true; // 버튼을 누르면 확장되도록
                                });
                              },
                              child: Text(
                                "+ Read More",
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: GlobalColors.mainColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: '통계',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: '캘린더',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '마이',
            ),
          ],
          selectedItemColor: GlobalColors.mainColor,
          unselectedItemColor: GlobalColors.darkgrayColor,
          backgroundColor: GlobalColors.whiteColor,
          selectedLabelStyle: TextStyle(
            fontSize: 9,
            color: GlobalColors.mainColor,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 9,
            color: GlobalColors.darkgrayColor,
          ),
        ),
      ),
    );
  }

  Widget get _displayDate {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${widget.date.year}',
          style: Theme.of(context).textTheme.labelMedium?.apply(
                color: GlobalColors.mainColor,
              ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  date = date.subtract(const Duration(days: 1));
                });
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 16,
              ),
            ),
            SizedBox(
              width: 200,
              child: Center(
                child: Text(
                  '${widget.date.month}월 ${widget.date.day}일, ${DateFormat('E', 'ko_KR').format(widget.date)}요일',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  date = date.add(const Duration(days: 1));
                });
              },
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  Future<void> fetchDiaryData(DateTime date) async {
//걍 데이터 더미 데이터
    diaryList = _generateMockDiaryData();
  }

  List<DiaryData> _generateMockDiaryData() {
    Random random = Random();
    List<DiaryData> diaryList = [];
    List<String> allEmotions = ['happy', 'sad', 'excited', 'nervous', 'calm'];
    List<String> allReasons = [
      'work',
      'family',
      'vacation',
      'exercise',
      'reading'
    ];

    for (int i = 0; i < 20; i++) {
      DateTime date = DateTime.now();
      int maxHeartRate = random.nextInt(40) + 80;
      int minHeartRate = random.nextInt(20) + 60;
      int avgHeartRate = (maxHeartRate + minHeartRate) ~/ 2;
      int stressLevel = random.nextInt(101);
      List<String> emotions = List.generate(random.nextInt(3) + 1,
          (_) => allEmotions[random.nextInt(allEmotions.length)]);
      List<String> reasons = List.generate(random.nextInt(3) + 1,
          (_) => allReasons[random.nextInt(allReasons.length)]);
      UserCondition condition = UserCondition(
        date: date,
        maxHeartRate: maxHeartRate,
        minHeartRate: minHeartRate,
        avgHeartRate: avgHeartRate,
        stressLevel: stressLevel,
      );
      DiaryData diary = DiaryData(
        userCondition: condition,
        emotions: emotions,
        reasons: reasons,
        content:
            ' ${emotions.join(", ")}, ${reasons.join(", ")}.50자 이상50자 이상50자 이상50자 이상50자 이상50자 이상50자 이상50자 이상50자 이상50자 이상50자 이상50자 이상50자 이상50자 이상',
        date: date,
      );
      diaryList.add(diary);
    }

    return diaryList;
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController _pageController = PageController(initialPage: 1);
  int _selectedIndex = 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        backgroundColor: GlobalColors.whiteColor,
        body: PageView(
          controller: _pageController,
          onPageChanged: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            // 통계
            AnalyzeView(),
            // 캘린더 홈
            CalendarView(),
            // 마이페이지
            MyPageView(),
          ],
        ),
      ),
    );
  }
}
