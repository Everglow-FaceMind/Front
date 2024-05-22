import 'package:facemind/utils/global_colors.dart';
import 'package:facemind/utils/user_store.dart';
import 'package:facemind/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//스크롤
class MyPageView extends StatefulWidget {
  const MyPageView({super.key});
  @override
  State<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: GlobalColors.whiteColor,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: GlobalColors.whiteColor,
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
              title: const Text('내 정보'),
            ),
            body: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //사용자 이름
                      Container(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          '${UserStore.to.currentUser?.nickname ?? 'nickname'} 님',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      //사용자 한줄소개
                      Container(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          '소개    ${UserStore.to.currentUser?.introduction ?? 'introduction'}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      //사용자 이메일
                      Container(
                        padding: const EdgeInsets.only(left: 18),
                        child: Text(
                          '이메일    ${UserStore.to.currentUser?.email ?? 'email'}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Divider(
                        //구분선
                        height: 28.0,
                        color: Colors.grey[400],
                        thickness: 1,
                      ),

                      //알림 설정
                      InkWell(
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          //알림 설정 뷰는 구현 안 함.
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 15),
                          child: const Text(
                            '알림 설정',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Divider(
                        //구분선
                        height: 28.0,
                        color: Colors.grey[400],
                        thickness: 1,
                      ),

                      //로그아웃
                      InkWell(
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          UserStore.to.updateUser(null);
                          Get.offAll(() => const LoginView());
                          //로그아웃
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 15),
                          child: const Text(
                            '로그아웃',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Divider(
                        //구분선
                        height: 28.0,
                        color: Colors.grey[400],
                        thickness: 1,
                      ),

                      //계정탈퇴
                      InkWell(
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            //계정탈퇴
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 15),
                            child: const Text(
                              '계정탈퇴', //계정탈퇴는 구현 안 함
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                          )),
                      Divider(
                        //구분선
                        height: 25.0,
                        color: Colors.grey[400],
                        thickness: 1,
                      ),
                    ]))),
      ),
    );
  }
}
