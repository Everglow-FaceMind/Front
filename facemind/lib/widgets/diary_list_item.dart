import 'dart:math';

import 'package:facemind/utils/double_extension.dart';
import 'package:flutter/material.dart';

import '../api/model/daily_journal_data.dart';
import '../utils/global_colors.dart';

class DiaryListItem extends StatefulWidget {
  final JournalEntry data;
  final GestureTapCallback? onDelete;
  final GestureTapCallback? onEdit;

  const DiaryListItem({
    super.key,
    required this.data,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<DiaryListItem> createState() => _DiaryListItemState();
}

class _DiaryListItemState extends State<DiaryListItem> {
  late final JournalEntry data = widget.data;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: GlobalColors.subBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.only(
          top: 10.0, right: 16.0, left: 16.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.stressRate.emoji,
                style: TextStyle(
                  fontSize: 40,
                  color: GlobalColors.darkgrayColor,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.stressRate.emojiText,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    data.time,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: widget.onEdit,
                    child: const Text(
                      "수정",
                      style: TextStyle(fontSize: 13, color: Color(0xffF59A2F)),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 14,
                      width: 0.5,
                      color: GlobalColors.darkgrayColor,
                    ),
                  ),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: widget.onDelete,
                    child: Text(
                      "삭제",
                      style: TextStyle(
                          fontSize: 13, color: GlobalColors.darkgreenColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (data.journalDetail != null)
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      '느낀 감정',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: GlobalColors.darkgrayColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      data.journalDetail?.emotion?.join(",") ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '감정의 원인',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: GlobalColors.darkgrayColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      data.journalDetail?.cause?.join(", ") ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Note',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        isExpanded
                            ? data.journalDetail?.note ?? ''
                            : (data.journalDetail?.note?.substring(
                                    0,
                                    min(data.journalDetail?.note?.length ?? 0,
                                        50)) ??
                                ''),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: GlobalColors.darkgrayColor,
                        ),
                      ),
                    ),
                  ],
                ),
                if ((data.journalDetail?.note?.length ?? 0) > 50 && !isExpanded)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isExpanded = true;
                      });
                    },
                    child: Text(
                      "+ Read More",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: GlobalColors.mainColor,
                      ),
                    ),
                  ),
              ],
            )
        ],
      ),
    );
  }
}
