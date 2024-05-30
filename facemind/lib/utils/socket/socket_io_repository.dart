import 'package:get/get.dart';

abstract class SocketClient {
  static SocketClient get to => Get.find();
  bool get isConnected;

  /// 소켓 연결
  /// return : 연결 성공 여부
  Future<bool> connect(Uri uri);

  /// 소켓 연결 해제
  void disconnect();

  /// 이벤트 전송
  void send(String event, dynamic data);

  /// 이벤트 수신
  void on(String event, Function(dynamic) callback);
}
