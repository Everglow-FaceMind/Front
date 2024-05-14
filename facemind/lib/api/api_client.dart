import 'package:facemind/api/model/user_info.dart';
import 'package:facemind/utils/user_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'model/enum.dart';
import 'model/home_calendar_response.dart';
import 'model/user_token.dart';

const String kBaseUrl =
    'http://facemind-env.eba-v3kmnqjm.ap-northeast-2.elasticbeanstalk.com';

class ApiClient {
  static ApiClient get to {
    return Get.find<ApiClient>();
  }

  final String baseUrl;
  http.Client httpClient;

  ApiClient({this.baseUrl = kBaseUrl, http.Client? client})
      : httpClient = client ?? http.Client();

  String? get accessToken {
    try {
      final userStore = Get.find<UserStore>();
      return userStore.currentUser?.token?.accessToken;
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String nickname,
    required bool alarmAllowance,
    required String introduction,
  }) async {
    var url = Uri.parse('$baseUrl/auth/signup');
    try {
      var response = await httpClient.post(
        url,
        body: jsonEncode({
          'email': email,
          'password': password,
          'nickname': nickname,
          'alarmAllowance': alarmAllowance,
          'introduction': introduction
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }

  Future<UserInfo?> login(String email, String password) async {
    var url = Uri.parse('$baseUrl/auth/login');
    try {
      var response = await httpClient.post(
        url,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final token = UserToken.fromJson(jsonDecode(response.body));
        // 현재 API에 유저 데이터를 받아오는 부분이 없어서 임시
        return UserInfo(
          email: email,
          token: token,
        );
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<UserToken?> refreshToken(
      String accessToken, String refreshToken) async {
    var url = Uri.parse('$baseUrl/auth/reissue');
    try {
      var response = await httpClient.post(
        url,
        body: jsonEncode({
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return UserToken.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// 홈 화면 데이터를 가져옴
  /// [date] 요청할 날짜
  /// [sort] 정렬 방식
  Future<HomeCalendarData?> fetchHomeData({
    required DateTime date,
    SortType sort = SortType.max,
  }) async {
    // Access token이 없으면 null!
    if (accessToken == null) {
      return null;
    }
    var queryParams = {
      'date': DateFormat('yyyy-MM-dd').format(date),
      'sort': sort.value,
    };
    var uri =
        Uri.parse('$baseUrl/result/home').replace(queryParameters: queryParams);

    try {
      var response = await httpClient.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return HomeCalendarData.fromJson(json.decode(response.body));
      } else {
        debugPrint('Error: ${response.body})');
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  void dispose() {
    httpClient.close();
  }
}
