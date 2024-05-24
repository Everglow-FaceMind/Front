import 'package:facemind/api/api_client.dart';
import 'package:facemind/utils/global_colors.dart';
import 'package:facemind/ui/common/widgets/appbar.dart';
import 'package:facemind/ui/common/widgets/charts/line_chart.dart';
import 'package:facemind/ui/common/widgets/charts/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api/model/statistics_data.dart';

class AnalyzeView extends StatefulWidget {
  final DateTime date;

  const AnalyzeView({
    super.key,
    required this.date,
  });
  @override
  State<AnalyzeView> createState() => _AnalyzeViewState();
}

class _AnalyzeViewState extends State<AnalyzeView> {
  DateTime date = DateTime.now();
  StatisticsData? statisticsData;

  @override
  void initState() {
    date = widget.date;
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GlobalColors.whiteColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            leading: const SizedBox(),
            leadingWidth: 10,
            shape: Border(
              bottom: BorderSide(
                color: Colors.grey[300]!,
                width: 0.5,
              ),
            ),
            title: const Text('통계'),
          ),
          backgroundColor: GlobalColors.whiteColor,
          body: Container(
            padding: const EdgeInsets.only(right: 35.0, left: 35.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    '${widget.date.year}',
                    style: Theme.of(context).textTheme.labelLarge?.apply(
                          color: GlobalColors.mainColor,
                        ),
                  ),
                  SizedBox(
                    width: 200,
                    child: Center(
                      child: Text(
                        '${widget.date.month}월 ${widget.date.day}일, ${DateFormat('E', 'ko_KR').format(widget.date)}요일',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 270,
                    child: LineChartSample1(
                        heartRate: statisticsData?.heartRate ?? []),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    child: PieChartSample2(
                        stressLevel: statisticsData?.stressLevel ?? []),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchData() async {
    final data = await ApiClient.to.fetchStatistics(date);
    setState(() {
      statisticsData = data;
    });
  }
}

Widget _header() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.only(left: 5),
        child: const Text(
          '측정 결과',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      Divider(
        height: 10.0,
        color: Colors.grey[500],
        thickness: 0.8,
      ),
    ],
  );
}
