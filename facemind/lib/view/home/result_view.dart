import 'package:facemind/model/user_condition.dart';
import 'package:facemind/utils/global_colors.dart';
import 'package:facemind/view/diary/new_diary.dart';
import 'package:facemind/view/home/home_view.dart';
import 'package:facemind/widgets/button_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Assets {
  static String resultImg = 'assets/Images/resultImg.png';
}

class ResultView extends StatefulWidget {
  final UserCondition userCondition;

  const ResultView({
    super.key,
    required this.userCondition,
  });

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.whiteColor,
      body: Container(
        padding: const EdgeInsets.all(35.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            //구분선
            height: 10.0,
            color: Colors.grey[500],
            thickness: 0.8,
          ),
          const SizedBox(height: 30),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: GlobalColors.subBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Text(
                  '심박수',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _displayStat(widget.userCondition),
                    Image.asset(
                      width: 100,
                      Assets.resultImg,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: GlobalColors.subBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Text(
                  '스트레스지수',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.userCondition.emoji,
                      style: TextStyle(
                        fontSize: 60,
                        color: GlobalColors.darkgrayColor,
                      ),
                    ),
                    _displayStress(widget.userCondition),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          ButtonGlobal(
            text: '일기 작성하기',
            onPressed: () {
              Get.to(NewDiaryView(
                date: DateTime.now(),
                userCondition: UserCondition(
                  date: DateTime.now(),
                  stressLevel: 20,
                  maxHeartRate: 100,
                  minHeartRate: 12,
                  avgHeartRate: 50,
                ),
                // controller: null,
              ));
            },
            buttonColor: GlobalColors.mainColor,
          ),
          const SizedBox(
            height: 15,
          ),
          ButtonGlobal(
            text: '홈으로',
            onPressed: () {
              Get.to(() => const HomeView());
            },
            buttonColor: GlobalColors.darkgrayColor,
          ),
        ]),
      ),
    );
  }
}

Widget _displayStat(UserCondition userCondition) {
  final avgHeartRate = userCondition.avgHeartRate;
  final maxHeartRate = userCondition.maxHeartRate;
  final minHeartRate = userCondition.minHeartRate;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '평균 ${avgHeartRate.toString()}',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        textAlign: TextAlign.left,
      ),
      Text(
        '최고 ${maxHeartRate.toString()}',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        textAlign: TextAlign.left,
      ),
      Text(
        '최저 ${minHeartRate.toString()}',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        textAlign: TextAlign.left,
      ),
    ],
  );
}

Widget _displayStress(UserCondition userCondition) {
  final stressLevel = userCondition.stressLevel;

  return Text(
    stressLevel.toString(),
    style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
    textAlign: TextAlign.left,
  );
}
