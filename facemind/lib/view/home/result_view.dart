import 'package:facemind/api/api_client.dart';
import 'package:facemind/model/user_condition.dart';
import 'package:facemind/utils/global_colors.dart';
import 'package:facemind/view/diary/diary_editor_view.dart';
import 'package:facemind/view/home/home_view.dart';
import 'package:facemind/widgets/button_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/double_extension.dart';
import '../../widgets/appbar.dart';

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
  late final UserCondition userCondition = widget.userCondition;
  int? resultId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      sendResult();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GlobalColors.whiteColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: GlobalColors.whiteColor,
          appBar: DefaultAppBar(
            title: const Text(
              '측정 결과',
            ),
          ),
          body: Container(
            padding:
                const EdgeInsets.only(right: 35.0, left: 35.0, bottom: 35.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Expanded(
                  child: _bodyView(context, widget.userCondition),
                ),
                _bottomButtonView(context, userCondition)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendResult() async {
    resultId = await ApiClient.to.writeResult(userCondition);
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

  Widget _bodyView(BuildContext context, UserCondition userCondition) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          _heartView(context, userCondition),
          const SizedBox(height: 30),
          _stressView(context, userCondition),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _bottomButtonView(BuildContext context, UserCondition userCondition) {
    return Column(
      children: [
        ButtonGlobal(
          text: '일기 작성하기',
          onPressed: () {
            if (resultId == null) {
              return;
            }
            Get.off(
              () => DiaryEditorView.createWriteMode(
                date: userCondition.date,
                userCondition: userCondition,
                resultId: resultId!,
              ),
            );
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
      ],
    );
  }

  Widget _stressView(BuildContext context, UserCondition userCondition) {
    return Container(
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
                userCondition.stressLevel.emoji,
                style: TextStyle(
                  fontSize: 60,
                  color: GlobalColors.darkgrayColor,
                ),
              ),
              _displayStress(userCondition),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _heartView(BuildContext context, UserCondition userCondition) {
    return Container(
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
              _displayStat(userCondition),
              Image.asset(
                width: 100,
                Assets.resultImg,
              ),
            ],
          ),
        ],
      ),
    );
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
}
