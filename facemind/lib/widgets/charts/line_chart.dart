import 'package:facemind/utils/global_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// LineChart를 구현하는 위젯입니다.
class _LineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      heartBeat, // sampleData1을 보여줍니다.
      duration: const Duration(milliseconds: 250), // 애니메이션 지속 시간 설정
    );
  }

  // 샘플 데이터를 생성하는 메서드입니다.
  LineChartData get heartBeat => LineChartData(
        lineTouchData: lineTouchData,
        gridData: gridData,
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: lineBarsData,
        minX: 0,
        maxX: 7,
        maxY: 150,
        minY: 0,
      );

  // 터치 동작을 제어하는 LineTouchData 객체입니다.
  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
        ),
      );

  // 표시되는 제목 데이터를 정의하는 FlTitlesData 객체입니다.
  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(showTitles: true),
        ),
      );

  // 왼쪽 축에 표시되는 제목 위젯을 생성하는 메서드입니다.
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 80:
        text = '80';
        break;
      case 95:
        text = '95';
        break;
      case 110:
        text = '110';
        break;
      case 125:
        text = '125';
        break;
      case 140:
        text = '140';
        break;
      default:
        text = '';
        break;
    }

    return Text(text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
        textAlign: TextAlign.center);
  }

  // 왼쪽 축의 제목을 정의하는 SideTitles 객체입니다.
  SideTitles leftTitles({required bool showTitles}) => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 15,
        reservedSize: 40,
      );

  // 아래쪽 축에 표시되는 제목 위젯을 생성하는 메서드입니다.
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('월', style: style);
        break;
      case 2:
        text = const Text('화', style: style);
        break;
      case 3:
        text = const Text('수', style: style);
        break;
      case 4:
        text = const Text('목', style: style);
        break;
      case 5:
        text = const Text('금', style: style);
        break;
      case 6:
        text = const Text('토', style: style);
        break;
      case 7:
        text = const Text('일', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      child: text,
    );
  }

  // 아래쪽 축의 제목을 정의하는 SideTitles 객체입니다.
  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  // 그리드를 정의하는 FlGridData 객체입니다.
  FlGridData get gridData => const FlGridData(show: true);

  // 그래프의 테두리를 정의하는 FlBorderData 객체입니다.
  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.2), width: 2),
          left: BorderSide(color: Colors.black.withOpacity(0.2), width: 2),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  // 라인 차트 바 데이터를 정의하는 메서드입니다.
  List<LineChartBarData> get lineBarsData => [
        LineChartBarData(
          spots: [
            FlSpot(1, 80),
            FlSpot(2, 95),
            FlSpot(3, 110),
            FlSpot(4, 125),
            FlSpot(5, 140),
            FlSpot(6, 135),
            FlSpot(7, 120),
          ],
          isCurved: true,
          color: GlobalColors.darkgrayColor,
          barWidth: 4,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(show: false),
          dotData: const FlDotData(show: false),
        ),
        LineChartBarData(
          spots: [
            FlSpot(1, 120),
            FlSpot(2, 130),
            FlSpot(3, 125),
            FlSpot(4, 135),
            FlSpot(5, 140),
            FlSpot(6, 130),
            FlSpot(7, 125),
          ],
          isCurved: true,
          color: GlobalColors.mainColor,
          barWidth: 4,
          isStrokeCapRound: true,
          belowBarData:
              BarAreaData(show: true, color: Colors.orange.withOpacity(0)),
          dotData: const FlDotData(show: false),
        ),
      ];
}

// LineChartSample1을 구현하는 StatelessWidget입니다.
class LineChartSample1 extends StatelessWidget {
  const LineChartSample1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: GlobalColors.subBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          Column(
            children: [
              const Text(
                '심박수 통계',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6, left: 6),
                  child: _LineChart(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
