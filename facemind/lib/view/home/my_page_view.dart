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
  late final UserStore _userStore = Get.find();

  @override
  Widget build(BuildContext context) {
    late final UserStore _userStore = Get.find();

    return Scaffold(
        backgroundColor: GlobalColors.whiteColor,
        body: SafeArea(
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 5),
                        child: const Text(
                          'MY',
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
                      const SizedBox(height: 10),

                      //사용자 이름
                      Container(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          '${_userStore.currentUser?.name ?? 'name'}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      //사용자 한줄소개
                      Container(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          '${_userStore.currentUser?.bio ?? 'bio'}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: 25),

                      //사용자 이메일
                      Container(
                        padding: const EdgeInsets.only(left: 18),
                        child: Text(
                          '이메일    ${_userStore.currentUser?.email ?? 'email'}',
                          style: TextStyle(
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
                            //알림 설정 뷰 구현 안 함.
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              '알림 설정',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                          )),
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
                            Get.offAll(() => const LoginView());
                            //로그아웃
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              '로그아웃',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                          )),
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
                            child: Text(
                              '계정탈퇴',
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
                    ]))));
  }
}
