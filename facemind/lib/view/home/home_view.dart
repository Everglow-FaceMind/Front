import 'package:facemind/utils/global_colors.dart';
import 'package:facemind/widgets/bottom_bar.dart';
// import 'package:facemind/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });
  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  late TabController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 3,
            initialIndex: 1, //홈을 기본으로
            child: Scaffold(
              backgroundColor: GlobalColors.whiteColor,
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  //통계
                  Container(),

                  // 캘린더 홈
                  Container(
                    padding: const EdgeInsets.all(35.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        const Text(
                          'name 님',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '오늘 날짜를 클릭하고',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          '심박수를 측정해보세요',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 30),
                        // const Dropdown(),
                        Container(
                          color: GlobalColors.subBgColor,
                          child: TableCalendar(
                            rowHeight: 45,
                            headerStyle: const HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true),
                            // calendarStyle: CalendarStyle(
                            //   defaultTextStyle: TextStyle(fontSize: 10.0),
                            // ),
                            calendarStyle: CalendarStyle(
                                selectedDecoration: BoxDecoration(
                              color: GlobalColors.lightgreenColor,
                              shape: BoxShape.circle,
                            )),
                            //오늘 날짜 색은 mainColor
                            availableGestures: AvailableGestures.all,
                            selectedDayPredicate: (day) =>
                                isSameDay(day, today),
                            focusedDay: today,
                            firstDay: DateTime.utc(2024),
                            lastDay: DateTime.utc(2030),
                            onDaySelected: _onDaySelected,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //마이페이지
                  Container(),
                ],
              ),
              bottomNavigationBar: Bottom(),
            )));
  }
}
