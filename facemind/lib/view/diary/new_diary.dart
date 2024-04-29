import 'package:facemind/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NewDiaryView extends StatefulWidget {
  // 페이지에 표시할 날짜 정보
  final DateTime date;

  const NewDiaryView({
    super.key,
    required this.date,
  });
  @override
  State<NewDiaryView> createState() => _NewDiaryViewState();
}

class _NewDiaryViewState extends State<NewDiaryView> {
  DateTime date = DateTime.now();

  @override
  void initState() {
    date = widget.date;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.whiteColor,
      body: Container(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                '일기 작성',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Divider(
              //구분선
              height: 10.0,
              color: Colors.grey[300],
              thickness: 1,
            ),
            SizedBox(height: 10),

            //날짜 표시

            Stack(_displayStat, _displayDate),

            // 일기 내용 여기에
          ],
        ),
      ),
    );
  }

  Widget get _displayStat {}
  Widget get _displayDate {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${widget.date.year}',
          style: Theme.of(context).textTheme.labelSmall?.apply(
                color: GlobalColors.mainColor,
              ),
        ),
        Text(
          '${widget.date.month}월 ${widget.date.day}일, ${DateFormat('E', 'ko_KR').format(widget.date)}요일',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
