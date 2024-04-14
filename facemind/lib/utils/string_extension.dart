extension StringExtension on String {
  String? get emailValidat {
    if (isEmpty) {
      return '이메일을 입력해주세요.';
    }
    // 이메일 형식을 확인하는 정규식
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(this)) {
      return '올바른 이메일 주소를 입력해주세요.';
    }
    return null;
  }

  String? get passwordValidat {
    if (length < 5) {
      return '비밀번호는 4자리 이상 입력해주세요.';
    }
    return null;
  }
}
