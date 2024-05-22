import 'package:facemind/api/api_client.dart';
import 'package:facemind/utils/double_extension.dart';
import 'package:facemind/utils/global_colors.dart';
import 'package:facemind/widgets/appbar.dart';
import 'package:facemind/widgets/button_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../api/model/journal_details.dart';
import '../../model/user_condition.dart';
import 'diary_view.dart';

enum WriteDirayMode {
  write,
  edit,
}

class DiaryEditorView extends StatefulWidget {
  // final TextEditingController controller;
  final DateTime date;

  final UserCondition? userCondition; // 일기 작성할때만 필요
  final int? resultId; // 일기 작성할때만 필요

  final int? journalId;

  const DiaryEditorView({
    super.key,
    required this.date,
    this.userCondition,
    this.resultId,
    this.journalId,
  });

  factory DiaryEditorView.createWriteMode({
    required DateTime date,
    required UserCondition userCondition,
    required int resultId,
  }) {
    return DiaryEditorView(
      date: date,
      userCondition: userCondition,
      resultId: resultId,
    );
  }

  factory DiaryEditorView.createEditMode({
    required DateTime date,
    required int journalId,
  }) {
    return DiaryEditorView(
      date: date,
      journalId: journalId,
    );
  }

  @override
  State<DiaryEditorView> createState() => _DiaryEditorViewState();
}

class _DiaryEditorViewState extends State<DiaryEditorView> {
  final TextEditingController _q3Controller = TextEditingController();
  late final UserCondition? _userCondition = widget.userCondition;
  late final WriteDirayMode _mode =
      widget.journalId == null ? WriteDirayMode.write : WriteDirayMode.edit;

  JournalDetails? _journalDetail;

  List<String> _emotions = [];
  List<String> _reasons = [];

  @override
  void initState() {
    super.initState();
    if (_mode == WriteDirayMode.edit) {
      _loadJournalDetails();
    }
  }

  @override
  void dispose() {
    _q3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: GlobalColors.whiteColor,
      appBar: DefaultAppBar(title: Text('일기 작성')),
      body: Container(
        padding: const EdgeInsets.only(
            top: 20.0, right: 35.0, left: 35.0, bottom: 35.0),
        child: Column(
          children: [
            Expanded(
              child: _bodyView(),
            ),
            ButtonGlobal(
              text: _mode == WriteDirayMode.write ? '작성 완료' : '수정하기',
              onPressed: _buttonEnabled
                  ? () {
                      if (_mode == WriteDirayMode.write) {
                        _sendDiary();
                      } else {
                        _editDiray();
                      }
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

  Widget _bodyView() {
    //화면 암데나 터치하면 키보드 내리기
    if (_userCondition == null && _journalDetail == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final stressLevel = _mode == WriteDirayMode.write
        ? _userCondition!.stressLevel
        : _journalDetail!.stressLevel;

    final avgHeartRate = _mode == WriteDirayMode.write
        ? _userCondition!.avgHeartRate
        : _journalDetail!.heartRateAvg;
    final maxHeartRate = _mode == WriteDirayMode.write
        ? _userCondition!.maxHeartRate
        : _journalDetail!.heartRateMax;
    final minHeartRate = _mode == WriteDirayMode.write
        ? _userCondition!.minHeartRate
        : _journalDetail!.heartRateMin;

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
                      stressLevel.emoji,
                      style: TextStyle(
                        fontSize: 55,
                        color: GlobalColors.darkgrayColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _displayStat(
                      avgHeartRate: avgHeartRate ?? 0,
                      maxHeartRate: maxHeartRate ?? 0,
                      minHeartRate: minHeartRate ?? 0,
                      stressLevel: stressLevel ?? 0.0,
                    ),
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
                      _input(_emotions, true);
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
              if (_emotions.isNotEmpty) _chipList(_emotions),
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
                      _input(_reasons, false);
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
              if (_reasons.isNotEmpty) _chipList(_reasons),
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
        ));
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
          height: 10.0,
          color: Colors.grey[300],
          thickness: 1,
        ),
      ],
    );
  }

  bool get _buttonEnabled {
    return _emotions.isNotEmpty && _reasons.isNotEmpty;
  }

  void _moveListPage() {
    Get.off(() => DiaryView(date: widget.date));
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
      // 다이얼로그가 종료 되면 키보드를 내림
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  void _addEmotionReason(bool isEmotion, String text) {
    if (isEmotion) {
      setState(() {
        _emotions.add(text);
      });
    } else {
      setState(() {
        _reasons.add(text);
      });
    }
  }

  Widget _displayStat({
    required int avgHeartRate,
    required int maxHeartRate,
    required int minHeartRate,
    required double stressLevel,
  }) {
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

  Future<void> _loadJournalDetails() async {
    final result =
        await ApiClient.to.fetchJournalDetails(widget.journalId.toString());
    if (result != null) {
      setState(() {
        _journalDetail = result;
        _q3Controller.text = _journalDetail?.note ?? '';
        _emotions = _journalDetail?.emotion ?? [];
        _reasons = _journalDetail?.cause ?? [];
      });
    }
  }

  Future<void> _editDiray() async {
    if (_mode != WriteDirayMode.edit) {
      return;
    }

    final result = await ApiClient.to.updateJournal(
      journalId: widget.journalId!.toString(),
      emotion: _emotions,
      cause: _reasons,
      note: _q3Controller.text,
    );

    if (result) {
      Get.back(result: true);
    } else {
      Get.snackbar('일지 수정 실패', '일지 수정에 실패하였습니다. 나중에 다시 시도해주세요.');
    }
  }

  Future<void> _sendDiary() async {
    if (widget.resultId == null) {
      Get.snackbar('일지 작성 실패', '일지 작성에 실패하였습니다. 나중에 다시 시도해주세요.');
      return;
    }

    final int? id = await ApiClient.to.writeJournal(
      resultId: widget.resultId!,
      emotion: _emotions,
      reason: _reasons,
      note: _q3Controller.text,
    );

    if (id == null) {
      Get.snackbar('일지 작성 실패', '일지 작성에 실패하였습니다. 나중에 다시 시도해주세요.');
    } else {
      Get.off(() => DiaryView(date: widget.date));
    }
  }
}
