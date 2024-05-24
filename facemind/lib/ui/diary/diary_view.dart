import 'package:facemind/api/api_client.dart';
import 'package:facemind/model/user_condition.dart';
import 'package:facemind/utils/global_colors.dart';
import 'package:facemind/ui/diary/diary_editor_view.dart';

import 'package:facemind/ui/common/widgets/diary_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../api/model/daily_journal_data.dart';
import '../common/widgets/appbar.dart';

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
  late DateTime date = widget.date;
  List<JournalEntry> diaryList = [];
  bool isExpanded = false; //note 내용 50자 이상 시 확장
  @override
  void initState() {
    super.initState();
    _fetchDiaryData(widget.date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GlobalColors.whiteColor,
      child: SafeArea(
        child: Scaffold(
          appBar: DefaultAppBar(
            title: const Text(
              '내 일기',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          backgroundColor: GlobalColors.whiteColor,
          body: Container(
            padding:
                const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _displayDate,
                Expanded(
                  child: ListView.builder(
                    itemCount: diaryList.length,
                    itemBuilder: (context, index) {
                      final diary = diaryList[index];
                      return DiaryListItem(
                        data: diary,
                        onDelete: () async {
                          final journalDetail = diary.journalDetail;
                          if (journalDetail != null) {
                            final result = await ApiClient.to.deleteJournal(
                                journalDetail.journalId!.toString());
                            if (result) {
                              Get.snackbar('일지 내용 삭제', '일지 내용이 삭제되었습니다.');
                              _fetchDiaryData(date);
                            } else {
                              Get.snackbar(
                                '일지 내용 삭제 실패',
                                '일지 내용 삭제에 실패했습니다.',
                              );
                            }
                          } else {
                            Get.snackbar(
                              '일지 내용 없음',
                              '일지 내용이 존재하지 않습니다.',
                            );
                          }
                        },
                        onEdit: () {
                          final journalDetail = diary.journalDetail;
                          if (journalDetail != null) {
                            Get.to(
                              () => DiaryEditorView.createEditMode(
                                date: date,
                                journalId: journalDetail.journalId!,
                              ),
                            )?.then((value) {
                              if (value == true) {
                                _fetchDiaryData(date).then((value) {
                                  Get.snackbar('일지 수정', '일지 내용이 수정되었습니다.');
                                });
                              }
                            });
                          } else {
                            // 일지가 없는 경우 새로 작성
                            Get.to(() => DiaryEditorView.createWriteMode(
                                  date: date,
                                  userCondition: UserCondition(
                                    date: date,
                                    stressLevel: diary.stressRate,
                                    avgHeartRate: diary.heartRateAvg,
                                    maxHeartRate: diary.heartRateMax,
                                    minHeartRate: diary.heartRateMin,
                                  ),
                                  resultId: diary.resultId ?? 0,
                                ))?.then((value) {
                              if (value == true) {
                                _fetchDiaryData(date).then((value) {
                                  Get.snackbar('일지 수정', '일지 내용이 수정되었습니다.');
                                });
                              }
                            });
                          }
                        },
                      );
                    },
                  ),
                )
              ],
            ),
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
          '${date.year}',
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
                date = date.subtract(const Duration(days: 1));
                setState(() {});
                _fetchDiaryData(date);
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
                  '${date.month}월 ${date.day}일, ${DateFormat('E', 'ko_KR').format(date)}요일',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                date = date.add(const Duration(days: 1));
                setState(() {});
                _fetchDiaryData(date);
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

  /// [date] : 가져올 일기 데이터의 날짜
  Future<void> _fetchDiaryData(DateTime date) async {
    setState(() {
      diaryList.clear();
    });
    final resultData = await ApiClient.to.fetchDailyJournals(date);
    setState(() {
      diaryList = resultData?.journals ?? [];
    });
  }
}
