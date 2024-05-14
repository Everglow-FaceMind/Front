import 'user_token.dart';

/// 유저 정보 모델
class UserInfo {
  final String? email;
  final String? nickname;
  final String? introduction;
  final UserToken? token;

  UserInfo({
    this.email,
    this.nickname,
    this.introduction,
    this.token,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      email: json['email'],
      nickname: json['nickname'],
      introduction: json['introduction'],
      token: json['token'] != null ? UserToken.fromJson(json['token']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'nickname': nickname,
      'introduction': introduction,
      'token': token?.toJson(),
    };
  }

  UserInfo copyWith({
    String? email,
    String? nickname,
    String? introduction,
    UserToken? token,
  }) {
    return UserInfo(
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      introduction: introduction ?? this.introduction,
      token: token ?? this.token,
    );
  }
}
