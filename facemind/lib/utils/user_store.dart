import '../model/user.dart';

/// 사용자 정보를 저장하는 클래스
class UserStore {
  // 현재 사용자 정보
  User? currentUser;
  UserStore({this.currentUser});

  /// 로그인 여부 확인 (currentUser가 null이면 로그아웃 상태)
  bool get isLogin => currentUser != null;

  /// 사용자 정보 업데이트
  void updateUser(User? user) {
    currentUser = user;
  }
}
