import 'package:facemind/utils/global_colors.dart';
import 'package:facemind/widgets/button_global.dart';
import 'package:flutter/material.dart';

class Agreement extends StatefulWidget {
  final VoidCallback onNext;

  const Agreement({
    super.key,
    required this.onNext,
  });

  @override
  State<Agreement> createState() => _AgreementState();
}

class _AgreementState extends State<Agreement> {
  List<bool> _isChecked = List.generate(4, (_) => false);
  bool get _buttonActive => _isChecked[1] && _isChecked[2];

  void _updateCheckState(int index) {
    setState(() {
      if (index == 0) {
        bool isAllChecked = !_isChecked.every((element) => element);
        _isChecked = List.generate(5, (index) => isAllChecked);
      } else {
        _isChecked[index] = !_isChecked[index];
        _isChecked[0] = _isChecked.getRange(1, 4).every((element) => element);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 120),
          ..._renderCheckList(),
          const Spacer(),
          ButtonGlobal(
            text: '다음',
            buttonColor: _buttonActive
                ? GlobalColors.mainColor
                : GlobalColors.darkgrayColor,
            onPressed: () {
              if (_buttonActive) {
                widget.onNext();
              }
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _renderCheckList() {
    List<String> labels = [
      '약관 전체동의',
      '이용약관 동의 (필수)',
      '개인정보 수집 및 이용동의 (필수)',
      'E-mail 및 SMS 광고성 정보 수신동의 (선택)',
    ];

    List<Widget> list = [
      renderContainer(_isChecked[0], labels[0], () => _updateCheckState(0)),
      const Divider(thickness: 1.0),
    ];

    list.addAll(List.generate(
        3,
        (index) => renderContainer(_isChecked[index + 1], labels[index + 1],
            () => _updateCheckState(index + 1))));

    return list;
  }

  Widget renderContainer(bool checked, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        color: Colors.white,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: checked ? GlobalColors.mainColor : Colors.grey,
                    width: 1.0),
                color: checked ? GlobalColors.mainColor : Colors.white,
              ),
              child: Icon(Icons.check,
                  color: checked ? GlobalColors.whiteColor : Colors.grey,
                  size: 13),
            ),
            const SizedBox(width: 5),
            Text(text,
                style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
