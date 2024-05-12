import 'package:facemind/utils/global_colors.dart';
import 'package:flutter/material.dart';

class Bottom extends StatelessWidget {
  const Bottom({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(width: 1.0, color: GlobalColors.darkgrayColor)),

          ///그림자 효과
        ),
        child: TabBar(
          labelColor: Colors.black,
          unselectedLabelColor: GlobalColors.darkgrayColor,
          indicatorColor: Colors.transparent,
          tabs: const <Widget>[
            Tab(
              icon: Icon(
                Icons.equalizer,
                size: 20,
              ),
              child: Text(
                '통계',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.home,
                size: 20,
              ),
              child: Text(
                '홈',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.person,
                size: 20,
              ),
              child: Text(
                '마이 페이지',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
