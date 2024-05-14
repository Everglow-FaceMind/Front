import 'dart:async';
import 'dart:convert';

import 'package:facemind/api/model/user_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kUserInfoKey = 'userInfo';

/// 사용자 정보를 저장하는 클래스
class UserStore {
  static UserStore get to => Get.find();

  // 현재 사용자 정보
  UserInfo? currentUser;
  UserStore({this.currentUser}) {
    debugPrint('UserStore 생성자');
  }

  // 저장한 유저 정보를 가져오는 부붖눈
  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(kUserInfoKey);
    if (json != null && json.isNotEmpty) {
      currentUser = UserInfo.fromJson(jsonDecode(json));
    }
  }

  /// 로그인 여부 확인 (currentUser가 null이면 로그아웃 상태)
  bool get isLogin => currentUser != null;

  /// 사용자 정보 업데이트
  Future<void> updateUser(UserInfo? user) async {
    currentUser = user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        kUserInfoKey, user == null ? '' : jsonEncode(user.toJson()));
  }
}
