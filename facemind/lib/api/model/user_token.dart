/// 유저 토큰 정보 모델
class UserToken {
  final String? grantType;
  final String? refreshToken;
  final String? accessToken;
  final int? accessTokenExpiresIn;

  UserToken({
    this.grantType,
    this.refreshToken,
    this.accessToken,
    this.accessTokenExpiresIn,
  });

  factory UserToken.fromJson(Map<String, dynamic> json) {
    return UserToken(
      grantType: json['grantType'],
      refreshToken: json['refreshToken'],
      accessToken: json['accessToken'],
      accessTokenExpiresIn: json['accessTokenExpiresIn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grantType': grantType,
      'refreshToken': refreshToken,
      'accessToken': accessToken,
      'accessTokenExpiresIn': accessTokenExpiresIn,
    };
  }
}
