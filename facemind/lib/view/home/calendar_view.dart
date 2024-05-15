import 'package:facemind/api/model/home_calendar_response.dart';
import 'package:facemind/api/model/enum.dart';
import 'package:facemind/api/model/user_info.dart';
import 'package:facemind/model/user_condition.dart';
import 'package:facemind/utils/user_store.dart';
import 'package:facemind/view/diary/diary_view.dart';
import 'package:facemind/view/diary/new_diary.dart';
import 'package:facemind/view/home/result_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../api/api_client.dart';
import '../../utils/global_colors.dart';
import '../../widgets/button_global.dart';
import '../../widgets/dropdown.dart';
import 'camera_view.dart';

class CalendarView extends StatefulWidget {
  final String name;
  const CalendarView({super.key, this.name = ''});
  @override
  State<StatefulWidget> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime? selectedDay;

  // 유저의 컨디션 정보가 저장된 리스트
  HomeCalendarData? _homeCalendarData;

  @override
  void initState() {
    super.initState();
    _fetchHomeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Spacer(),
        _header(),
        const Spacer(),
        _calendar(),
        const Spacer(),
        ButtonGlobal(
          text: '심박수 측정하기',
          onPressed: () {
            Get.to(() => const CameraView());
          },
          buttonColor: GlobalColors.mainColor,
        ),
        const Spacer(),
      ]),
    );
  }

  Future<void> _fetchHomeData() async {
    final result = await ApiClient.to.fetchHomeData(date: DateTime.now());
    setState(() {
      _homeCalendarData = result;
      UserStore.to.updateUser(
        UserStore.to.currentUser?.copyWith(
          nickname: result?.nickname ?? '',
        ),
      );
    });
  }

  Widget _calendar() {
    return Container(
      // 캘린더 전체 영역을 감싸는 컨테이너
      // decoration을 통해서 모서리를 둥글게 만들고 배경색을 넣어줌
      decoration: BoxDecoration(
        color: GlobalColors.subBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 36,
            width: double.maxFinite,
            child: Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: 28,
                width: 100,
                child: Dropdown(),
              ),
            ),
          ),
          TableCalendar(
            locale: 'ko_KR',
            rowHeight: 45, // 날짜 셀의 높이
            daysOfWeekHeight: 36, // 요일 표시 높이
            sixWeekMonthsEnforced: true, // 해당 옵션을 true하면 6주로 고정하여 표시
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) => _dayCell(day),
              outsideBuilder: (context, day, focusedDay) =>
                  _outsideDayCell(day),
              selectedBuilder: (context, day, focusedDay) => _dayCell(day),
              // 오늘 날짜 표시
              todayBuilder: (context, day, focusedDay) => _todayCell(day),
              markerBuilder: (context, day, events) => _markerCell(day),
            ),
            headerStyle: HeaderStyle(
              titleTextStyle: const TextStyle(
                fontSize: 15.0,
              ),
              formatButtonVisible: false,
              titleCentered: true,
              headerPadding: EdgeInsets.zero,
              // 상단에 왼쪽, 오른쪽 화살표 색상을 변경
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: GlobalColors.darkgrayColor,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: GlobalColors.darkgrayColor,
              ),
            ),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(day, selectedDay),
            focusedDay: selectedDay ??
                DateTime.now(), // 포커스된 날짜를 선택한 날짜로 설정 만약 선택된 날짜가 없으면 현재로
            firstDay: DateTime.utc(2024),
            lastDay: DateTime.utc(2030),
            onDaySelected: _onDaySelected,
          ),
          const SizedBox(height: 8)
        ],
      ),
    );
  }

  /// 상단 헤더 부분
  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 30),
        Text(
          '${_homeCalendarData?.nickname ?? ''}님',
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 23.0, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        const Text(
          '페이스마인드에서',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
        ),
        const SizedBox(height: 5),
        const Text(
          '심박수를 측정해보세요',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }

  Widget _dayCell(DateTime day) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 5),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          DateFormat('d').format(day),
          style: TextStyle(
            fontSize: 9.0,
            color: GlobalColors.darkgrayColor,
          ),
        ),
      ),
    );
  }

  Widget _outsideDayCell(DateTime day) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 5),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          DateFormat('d').format(day),
          style: TextStyle(
            fontSize: 9.0,
            color: GlobalColors.darkgrayColor.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget _selectedDayCell(DateTime day) {
    return Container(
      decoration: BoxDecoration(
        color: GlobalColors.mainColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          top: 5,
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            DateFormat('d').format(day),
            style: TextStyle(
              fontSize: 9.0,
              color: GlobalColors.whiteColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _todayCell(DateTime day) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 5),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          DateFormat('d').format(day),
          style: TextStyle(
            fontSize: 9.0,
            color: GlobalColors.mainColor,
          ),
        ),
      ),
    );
  }

  Widget _markerCell(DateTime day) {
    // 해당 날짜의 컨디션 정보를 가져옴
    final condition = _homeCalendarData?.results.where((element) {
      final dateText = DateFormat('yyyy-MM-dd').format(day);
      return element.date == dateText;
    }).firstOrNull;

    if (condition != null) {
      return Center(
        child: Text(
          condition.emoji,
          style: TextStyle(
            fontSize: 18,
            color: GlobalColors.darkgrayColor,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedDay = day;
    });
    // Get.to(() => DiaryView(date: day));
    Get.to(ResultView(
      userCondition: UserCondition(
        date: DateTime.now(),
        stressLevel: 20,
        maxHeartRate: 100,
        minHeartRate: 12,
        avgHeartRate: 50,
      ),
      // controller: null,
    ));
  }
}
