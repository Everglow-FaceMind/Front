import 'package:facemind/api/model/home_calendar_response.dart';
import 'package:facemind/model/user_condition.dart';
import 'package:facemind/utils/user_store.dart';
import 'package:facemind/ui/diary/diary_view.dart';
import 'package:facemind/ui/home/result_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../api/api_client.dart';
import '../../api/model/enum.dart';
import '../../utils/global_colors.dart';
import '../common/widgets/button_global.dart';
import '../common/widgets/dropdown.dart';
import '../camera/view/camera_stream.dart';

class CalendarView extends StatefulWidget {
  final String name;
  const CalendarView({super.key, this.name = ''});
  @override
  State<StatefulWidget> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime? selectedDay;
  DateTime? focuseDay;

  // 유저의 컨디션 정보가 저장된 리스트
  HomeCalendarData? _homeCalendarData;
  SortType sortType = SortType.max;

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
            Get.to(() => const CameraStream());
          },
          buttonColor: GlobalColors.mainColor,
        ),
        const Spacer(flex: 2),
      ]),
    );
  }

  /// 서버에 홈 데이터를 요청
  /// 캘린더에서 다른 날짜로 이동하거나, 정렬 타입을 변경할 때 호출함
  /// [date] : 날짜
  /// [sortType] : 정렬 타입
  ///
  /// [date]와 [sortType]이 null이면 현재 날짜와 정렬 타입으로 요청함
  Future<void> _fetchHomeData({
    DateTime? date,
    SortType? sortType,
  }) async {
    final result = await ApiClient.to.fetchHomeData(
        date: date ?? DateTime.now(), sort: sortType ?? this.sortType);
    setState(() {
      _homeCalendarData = result;
    });
  }

  Widget _calendar() {
    return Container(
      decoration: BoxDecoration(
        color: GlobalColors.subBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 36,
            width: double.maxFinite,
            child: Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: 28,
                width: 100,
                child: SortDropdown(
                  onChanged: (sortType) {
                    _fetchHomeData(date: focuseDay, sortType: sortType);
                  },
                ),
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
            focusedDay: focuseDay ?? DateTime.now(),
            firstDay: DateTime.utc(2024),
            lastDay: DateTime.utc(2030),
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay) {
              focuseDay = focusedDay;
              _fetchHomeData(date: focusedDay);
            },
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
        Text(
          '${UserStore.to.currentUser?.nickname ?? ''}님',
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
    Get.to(() => DiaryView(date: day));
  }
}
