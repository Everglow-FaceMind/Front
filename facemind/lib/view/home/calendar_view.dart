import 'package:facemind/model/user_condition.dart';
import 'package:facemind/utils/user_store.dart';
import 'package:facemind/view/diary/diary_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

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
  late final UserStore _userStore = Get.find();
  DateTime? selectedDay;

  final List<UserCondition> _conditionList = [];

  @override
  void initState() {
    super.initState();
    _fetchConditionList().then((value) {
      setState(() {});
    });
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

  /// 컨디션 리스트를 가져오는 함수
  /// 추후 서버에서 데이터를 가져오게 변경해야함
  Future<void> _fetchConditionList() async {
    // 서버에서 데이터를 가져오는 부분
    // 지금은 UI확인을 위해 임시 데이터를 넣어둠
    _conditionList.addAll([
      UserCondition(date: DateTime.now(), stressLevel: 20),
      UserCondition(
          date: DateTime.now().add(const Duration(days: 1)), stressLevel: 40),
      UserCondition(
          date: DateTime.now().add(const Duration(days: 3)), stressLevel: 60),
      UserCondition(
          date: DateTime.now().subtract(const Duration(days: 2)),
          stressLevel: 80),
      UserCondition(
          date: DateTime.now().subtract(const Duration(days: 4)),
          stressLevel: 100),
      UserCondition(
          date: DateTime.now().add(const Duration(days: 6)), stressLevel: 30),
      UserCondition(
          date: DateTime.now().subtract(const Duration(days: 7)),
          stressLevel: 0),
    ]);
  }

  Widget _calendar() {
    return Container(
      // 캘린더 전체 영역을 감싸는 컨테이너
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
          '${_userStore.currentUser?.name ?? ''}님',
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
    final condition = _conditionList
        .where((element) => isSameDay(element.date, day))
        .firstOrNull;

    if (condition != null) {
      return Center(
        child: Text(
          condition.emoji,
          style: TextStyle(
            fontSize: 12,
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
    Get.to(() => DiaryView(date: day));
  }
}
