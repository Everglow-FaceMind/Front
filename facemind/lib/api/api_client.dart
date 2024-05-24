import 'package:facemind/api/model/user_info.dart';
import 'package:facemind/model/user_condition.dart';
import 'package:facemind/utils/user_store.dart';
import 'package:facemind/ui/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'model/daily_journal_data.dart';
import 'model/enum.dart';
import 'model/home_calendar_response.dart';
import 'model/journal_details.dart';
import 'model/statistics_data.dart';
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
        final responseBody =
            jsonDecode(_uft8Convert(response.body)); // Map<String, dynamic>
        final token = UserToken.fromJson(responseBody['tokenInfo']);
        final userInfo = UserInfo.fromJson(responseBody['memberInfo']);
        return userInfo.copyWith(token: token);
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
        return UserToken.fromJson(json.decode(_uft8Convert(response.body)));
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
        return HomeCalendarData.fromJson(
            json.decode(_uft8Convert(response.body)));
      } else if (response.statusCode == 401) {
        if (await refreshUpdateAccessToken()) {
          return fetchHomeData(date: date, sort: sort);
        } else {
          Get.offAll(() => const LoginView());
          return null;
        }
      } else {
        debugPrint('Error: ${_uft8Convert(response.body)})');
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  /// 통계 데이터 가져오는 부분
  /// [date] 요청할 날짜
  Future<StatisticsData?> fetchStatistics(DateTime date) async {
    // Access token이 없으면 null을 반환!
    if (accessToken == null) {
      return null;
    }

    var queryParams = {
      'date': DateFormat('yyyy-MM-dd').format(date),
    };
    var uri = Uri.parse('$baseUrl/result/statistics')
        .replace(queryParameters: queryParams);

    try {
      var response = await httpClient.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return StatisticsData.fromJson(
            json.decode(_uft8Convert(response.body)));
      } else if (response.statusCode == 401) {
        if (await refreshUpdateAccessToken()) {
          return fetchStatistics(date);
        } else {
          Get.offAll(() => const LoginView());
          return null;
        }
      } else {
        debugPrint('Error: ${_uft8Convert(response.body)})');
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  /// 일기 작성!
  /// 작성할때 result ID값이 어떤 값인지 확인이 필요함!!
  ///
  /// [emotion] 감정 리스트 (필수)
  /// [reason] 이유 리스트 (필수)
  /// [note] 메모 (선택) 내용이 없는 경우 null
  ///
  /// 작성 성공시 일기 ID 반환
  Future<int?> writeJournal({
    required int resultId,
    required List<String> emotion,
    required List<String> reason,
    String? note,
  }) async {
    // Access token이 없으면 null을 반환
    if (accessToken == null) {
      return null;
    }
    var uri = Uri.parse('$baseUrl/journals/$resultId');
    try {
      var response = await httpClient.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'emotions': emotion,
          'cause': reason,
          'note': note,
        }),
      );

      final result = json.decode(_uft8Convert(response.body));
      if (response.statusCode == 200) {
        return result['journalId'];
      } else if (response.statusCode == 401) {
        if (await refreshUpdateAccessToken()) {
          return writeJournal(
            resultId: resultId,
            emotion: emotion,
            reason: reason,
          );
        } else {
          Get.offAll(() => const LoginView());

          return null;
        }
      } else {
        debugPrint('Error: ${_uft8Convert(response.body)})');
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  /// 일기 수정하는 부분
  /// [journalId] 수정할 일기 ID
  /// [emotion] 감정 리스트 (필수)
  /// [cause] 이유 리스트 (필수)
  /// [note] 메모 (선택) 내용이 없는 경우 null
  ///
  /// 수정 성공시 true 반환
  Future<bool> updateJournal({
    required String journalId,
    required List<String> emotion,
    required List<String> cause,
    String? note,
  }) async {
    if (accessToken == null) {
      return false;
    }
    var uri = Uri.parse('$baseUrl/journals/$journalId');
    try {
      var response = await httpClient.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'emotions': emotion,
          'cause': cause,
          'note': note,
        }),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(_uft8Convert(response.body));
        return responseData['message'] != null;
      } else if (response.statusCode == 401) {
        if (await refreshUpdateAccessToken()) {
          return updateJournal(
            journalId: journalId,
            emotion: emotion,
            cause: cause,
            note: note,
          );
        } else {
          Get.offAll(() => const LoginView());

          return false;
        }
      } else {
        debugPrint('Error: ${_uft8Convert(response.body)})');
        return false;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }

  /// 일기 삭제
  /// [journalId] 삭제할 일기 ID
  /// 삭제 성공시 true 반환
  Future<bool> deleteJournal(String journalId) async {
    // Access token이 없으면 null을 반환
    if (accessToken == null) {
      return false;
    }
    var uri = Uri.parse('$baseUrl/journals/$journalId');
    try {
      var response = await httpClient.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(_uft8Convert(response.body));
        return responseData['message'] != null;
      } else if (response.statusCode == 401) {
        if (await refreshUpdateAccessToken()) {
          return deleteJournal(journalId);
        } else {
          Get.offAll(() => const LoginView());
          return false;
        }
      } else {
        debugPrint('Error: ${_uft8Convert(response.body)})');
        return false;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }

  /// 일기 상세 정보
  /// [journalId] 일기 ID
  ///
  /// 성공시 JournalDetails 반환
  Future<JournalDetails?> fetchJournalDetails(String journalId) async {
    if (accessToken == null) {
      return null;
    }
    var uri = Uri.parse('$baseUrl/journals/$journalId');
    try {
      var response = await httpClient.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return JournalDetails.fromJson(
            json.decode(_uft8Convert(response.body)));
      } else if (response.statusCode == 401) {
        if (await refreshUpdateAccessToken()) {
          return fetchJournalDetails(journalId);
        } else {
          Get.offAll(() => const LoginView());
          return null;
        }
      } else {
        debugPrint('Error: ${_uft8Convert(response.body)})');
        return null;
      }
    } catch (e) {
      debugPrint('Error: ${e.toString()})');
      return null;
    }
  }

  /// 일기 목록 가져옴
  ///
  /// [date] 요청할 날짜
  Future<DailyJournalData?> fetchDailyJournals(DateTime date) async {
    var queryParams = {
      'date': DateFormat('yyyy-MM-dd').format(date),
    };
    var uri = Uri.parse('$baseUrl/journals/daily')
        .replace(queryParameters: queryParams);

    try {
      var response = await httpClient.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return DailyJournalData.fromJson(
            json.decode(_uft8Convert(response.body)));
      } else if (response.statusCode == 401) {
        if (await refreshUpdateAccessToken()) {
          return fetchDailyJournals(date);
        } else {
          Get.offAll(() => const LoginView());

          return null;
        }
      } else {
        debugPrint('Error: ${_uft8Convert(response.body)})');
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  /// 측정 결과를 서버에 보내서 저장
  /// [condition] 측정 결과
  ///
  /// 성공시 resultId를 반환
  Future<int?> writeResult(UserCondition condition) async {
    // Access token이 없으면 null을 반환
    if (accessToken == null) {
      return null;
    }
    var uri = Uri.parse('$baseUrl/result/test');
    try {
      var response = await httpClient.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          "date": DateFormat('yyyy-MM-dd').format(condition.date),
          "time": DateFormat('HH:mm:ss').format(condition.date),
          "heartRateMin": condition.minHeartRate,
          "heartRateMax": condition.maxHeartRate,
          "heartRateAvg": condition.avgHeartRate,
          "stressRate": condition.stressLevel.toInt(),
        }),
      );

      if (response.statusCode == 200) {
        final result = json.decode(_uft8Convert(response.body));
        return result['resultId'];
      } else if (response.statusCode == 401) {
        if (await refreshUpdateAccessToken()) {
          return writeResult(condition);
        } else {
          Get.offAll(() => const LoginView());
          return null;
        }
      } else {
        debugPrint('Error: ${_uft8Convert(response.body)})');
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  Future<bool> refreshUpdateAccessToken() async {
    final userStore = Get.find<UserStore>();
    final currentUser = userStore.currentUser;
    if (currentUser == null) {
      return false;
    }

    final newToken = await refreshToken(
      currentUser.token?.accessToken ?? '',
      currentUser.token?.refreshToken ?? '',
    );

    if (newToken != null) {
      await userStore.updateUser(
        currentUser.copyWith(token: newToken),
      );
      return true;
    } else {
      await userStore.updateUser(
        currentUser.copyWith(token: null),
      );
      return false;
    }
  }

  void dispose() {
    httpClient.close();
  }

  String _uft8Convert(String value) {
    return utf8.decode(value.codeUnits);
  }
}
