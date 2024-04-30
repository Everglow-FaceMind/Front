import 'package:facemind/utils/global_colors.dart';
import 'package:facemind/widgets/button_global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class NewDiaryView extends StatefulWidget {
  final DateTime date;

  const NewDiaryView({
    super.key,
    required this.date,
  });

  @override
  State<NewDiaryView> createState() => _NewDiaryViewState();
}

class _NewDiaryViewState extends State<NewDiaryView> {
  late DateTime date;
  List<String> emotions = [];

  @override
  void initState() {
    date = widget.date;
    super.initState();
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
            const SizedBox(height: 10),
            SizedBox(
              child: Row(
                children: [
                  _displayStat,
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
                _buildEmotionInputs(),
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '엔터를 사용해서 등록할 수 있습니다. (최대 3개)\n등록한 값을 터치하면 삭제됩니다.',
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
                _buildEmotionInputs(),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '엔터를 사용해서 등록할 수 있습니다. (최대 3개)\n등록한 값을 터치하면 삭제됩니다.',
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
                Text(
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
                height: 100,
                // 캘린더 전체 영역을 감싸는 컨테이너
                decoration: BoxDecoration(
                  color: GlobalColors.subBgColor,
                  borderRadius: BorderRadius.circular(16),
                )),
            const SizedBox(height: 25),
            ButtonGlobal(
              text: '작성 완료',
              onPressed: () {},
              buttonColor: GlobalColors.darkgrayColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionInputs() {
    List<Widget> emotionWidgets = [];

    for (int i = 0; i < emotions.length; i++) {
      emotionWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              emotions.removeAt(i);
            });
          },
          child: Text(
            emotions[i],
          ),
        ),
      );
    }

    if (emotions.length < 3) {
      emotionWidgets.add(
        GestureDetector(
          onTap: () {
            _showInputDialog();
          },
          child: const Text(
            ' ______',
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: emotionWidgets,
    );
  }

  void _showInputDialog() {
    showDialog(
      barrierColor: Color.fromARGB(162, 161, 161, 161),
      context: context,
      builder: (BuildContext context) {
        String emotion = '';
        return AlertDialog(
          backgroundColor: GlobalColors.subBgColor,
          surfaceTintColor: GlobalColors.whiteColor,
          title: const Text(
            '감정 입력',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: TextField(
            cursorColor: GlobalColors.darkgreenColor,
            onChanged: (value) {
              emotion = value;
            },
            onSubmitted: (value) {
              if (emotion.isNotEmpty) {
                setState(() {
                  emotions.add(emotion);
                });
                Navigator.pop(context);
              }
            },
            decoration: const InputDecoration(
              //textfield 밑줄 호버 시 색 black
              hintText: '어떤 감정을 느꼈나요?',
            ),
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
                if (emotion.isNotEmpty) {
                  setState(() {
                    emotions.add(emotion);
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('등록',
                  style: TextStyle(color: GlobalColors.darkgreenColor)),
            ),
          ],
        );
      },
    );
  }

  Widget get _displayStat {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '평균',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          textAlign: TextAlign.left,
        ),
        Text(
          '최고',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          textAlign: TextAlign.left,
        ),
        Text(
          '최저',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          textAlign: TextAlign.left,
        ),
        Text(
          '스트레스 지수',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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
