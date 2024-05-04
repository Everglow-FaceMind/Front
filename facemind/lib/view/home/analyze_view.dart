import 'package:facemind/widgets/charts/line_chart.dart';
import 'package:facemind/widgets/charts/pie_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalyzeView extends StatefulWidget {
  const AnalyzeView({super.key});
  @override
  State<AnalyzeView> createState() => _AnalyzeViewState();
}

class _AnalyzeViewState extends State<AnalyzeView> {
  // https://pub.dev/packages/fl_chart
  // LineChart, PieChart

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 5),
            child: const Text(
              '통계',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Divider(
            //구분선
            height: 10.0,
            color: Colors.grey[500],
            thickness: 0.8,
          ),
          Container(
            height: 270, // 원하는 높이 설정
            child: LineChartSample1(),
          ),
          Container(
            height: 200,
            child: PieChartSample2(),
          )
        ],
      ),
    );
  }
}



// {
//     "date": "2024-04-30",
//     "dayOfTheWeek": "화요일",
//     "heartRate" : [
// 		    {
// 				    "date": "2024-04-27",
// 				    "dayOfTheWeek": "월요일",
// 				    "heartRateMax" : 150,
// 				    "heartRateMin" : 40
// 		    },
// 		    {...}  
//     ]
//     "stressLevel": [
//         {
//             "level" : 1
//             "percentage" : 10
//         },
//         {...}
//     ]
// }