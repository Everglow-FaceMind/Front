import 'package:facemind/utils/global_colors.dart';
import 'package:facemind/widgets/button_global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../model/user_condition.dart';
import 'diary_view.dart';

class NewDiaryView extends StatefulWidget {
  final DateTime date;
  final UserCondition userCondition;

  const NewDiaryView({
    super.key,
    required this.date,
    required this.userCondition,
  });

  @override
  State<NewDiaryView> createState() => _NewDiaryViewState();
}

class _NewDiaryViewState extends State<NewDiaryView> {
  final TextEditingController _q3Controller = TextEditingController();

  List<String> emotions = [];
  List<String> reasons = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _q3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.whiteColor,
      body: Container(
        padding: const EdgeInsets.only(
            top: 65.0, right: 35.0, left: 35.0, bottom: 35.0),
        child: Column(
          children: [
            _headerView(),
            Expanded(
              child: _bodyView(),
            ),
            ButtonGlobal(
              text: '작성 완료',
              onPressed: _buttonEnabled
                  ? () {
                      _moveListPage();
                    }
                  : null,
              buttonColor: _buttonEnabled
                  ? GlobalColors.mainColor
                  : GlobalColors.darkgrayColor,
            ),
          ],
        ),
      ),
    );
  }

  bool get _buttonEnabled {
    return emotions.isNotEmpty && reasons.isNotEmpty;
  }

  void _moveListPage() {
    Get.to(() => DiaryView(date: DateTime.now()));
  }

  Widget _headerView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 15),
          child: const Text(
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
      ],
    );
  }

  Widget _bodyView() {
    //화면 암데나 터치하면 키보드 내리기
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: Row(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    widget.userCondition.emoji,
                    style: TextStyle(
                      fontSize: 55,
                      color: GlobalColors.darkgrayColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _displayStat(widget.userCondition),
                  const Spacer(),
                  _displayDate,
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Q1 ',
                  style: TextStyle(
                    color: GlobalColors.darkgreenColor,
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  '나는',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                _underLine(
                  () {
                    _input(emotions, true);
                  },
                ),
                const SizedBox(width: 4),
                const Text(
                  '한 감정을 느꼈다.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (emotions.isNotEmpty) _chipList(emotions),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '빈칸을 클릭하여 감정을 등록하세요. (최대 3개)',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: GlobalColors.darkyellow,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Q2 ',
                  style: TextStyle(
                    color: GlobalColors.darkgreenColor,
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  '내 감정의 원인은',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                _underLine(
                  () {
                    _input(reasons, false);
                  },
                ),
                const SizedBox(width: 4),
                const Text(
                  '이다.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
            if (reasons.isNotEmpty) _chipList(reasons),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '빈칸을 클릭하여 감정을 등록하세요. (최대 3개)',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: GlobalColors.darkyellow,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Q3 ',
                  style: TextStyle(
                    color: GlobalColors.darkgreenColor,
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  '그 일의 객관적인 사실만 묘사해보세요.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: GlobalColors.subBgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _q3Controller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(30)),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _underLine(void Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 36,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.only(bottom: 4),
            height: 1,
            width: 60,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _chipList(List<String> list) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: list
            .map(
              (e) => Chip(
                backgroundColor: GlobalColors.subBgColor,
                deleteIconColor: GlobalColors.mainColor,
                label: Text(e),
                onDeleted: () {
                  setState(() {
                    list.remove(e);
                  });
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _input(List<String> textList, bool isEmotion) {
    if (textList.length < 3) {
      _showInputDialog(isEmotion);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: GlobalColors.subBgColor,
          content: const Text(
            '최대 3개까지 등록 가능합니다.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      );
    }
  }

  void _showInputDialog(bool isEmotion) {
    showDialog(
      barrierColor: const Color.fromARGB(162, 161, 161, 161),
      context: context,
      builder: (BuildContext context) {
        String text = '';
        return AlertDialog(
          backgroundColor: GlobalColors.subBgColor,
          surfaceTintColor: GlobalColors.whiteColor,
          title: Text(
            isEmotion ? '어떤 감정을 느꼈나요?' : '감정의 원인은 무엇인가요?',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: TextField(
            cursorColor: GlobalColors.darkgreenColor,
            onChanged: (value) {
              text = value;
            },
            onSubmitted: (value) {
              _addEmotionReason(isEmotion, text);
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소',
                  style: TextStyle(color: GlobalColors.darkgreenColor)),
            ),
            TextButton(
              onPressed: () {
                _addEmotionReason(isEmotion, text);
                Navigator.pop(context);
              },
              child: Text('등록',
                  style: TextStyle(color: GlobalColors.darkgreenColor)),
            ),
          ],
        );
      },
    ).then((value) {
      //다이얼로그 종료 되면 키보드 아래로 내려가게!!
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  void _addEmotionReason(bool isEmotion, String text) {
    if (isEmotion) {
      setState(() {
        emotions.add(text);
      });
    } else {
      setState(() {
        reasons.add(text);
      });
    }
  }

  Widget _displayStat(UserCondition userCondition) {
    final avgHeartRate = userCondition.avgHeartRate;
    final maxHeartRate = userCondition.maxHeartRate;
    final minHeartRate = userCondition.minHeartRate;
    final stressLevel = userCondition.stressLevel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '평균 ${avgHeartRate.toString()}',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          textAlign: TextAlign.left,
        ),
        Text(
          '최고 ${maxHeartRate.toString()}',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          textAlign: TextAlign.left,
        ),
        Text(
          '최저 ${minHeartRate.toString()}',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          textAlign: TextAlign.left,
        ),
        Text(
          '스트레스 지수 ${stressLevel.toString()}',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Widget get _displayDate {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${widget.date.year}',
          style: Theme.of(context).textTheme.labelMedium?.apply(
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
