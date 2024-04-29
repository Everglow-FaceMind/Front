import 'package:facemind/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DiaryView extends StatefulWidget {
  // 페이지에 표시할 날짜 정보
  final DateTime date;

  const DiaryView({
    super.key,
    required this.date,
  });
  @override
  State<DiaryView> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryView> {
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
      appBar: AppBar(
        title: const Text('내 일기'),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _displayDate,
          // 일기 내용 여기에
        ],
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
                  '${widget.date.month}월${widget.date.day}일, ${DateFormat('E', 'ko_KR').format(widget.date)}요일',
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
}
