import 'dart:async';
import 'dart:convert';

import 'package:facemind/utils/socket/socket_io_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketIoClient extends SocketClient {
  Socket? _socket;
  bool _isConnected = false;
  final Map<String, Function(dynamic)> _callbacks = {};

  @override
  Future<bool> connect(Uri uri) async {
    Completer<bool> completer = Completer();
    if (!kIsWeb) {
      _socket = io(uri.toString(), <String, dynamic>{
        'transports': ['websocket']
      });
    } else {
      _socket = io(uri.toString());
    }
    _socket?.onConnect((_) {
      if (completer.isCompleted) return;
      debugPrint('connected!');
      _isConnected = true;
      completer.complete(true);
    });
    _socket?.onAny((event, data) {
      if (_isConnected == false) return;
      // debugPrint('event: $event, data: ${jsonEncode(data)}');
      _callbacks[event]?.call(data);
    });
    _socket?.onDisconnect((_) {
      debugPrint('disconnected!');
      _isConnected = false;
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    });

    return completer.future;
  }

  @override
  void disconnect() {
    _socket?.disconnect();
    _callbacks.clear();
  }

  @override
  void on(String event, Function(dynamic) callback) {
    _callbacks[event] = callback;
  }

  @override
  bool get isConnected => _isConnected;

  @override
  void send(String event, data) {
    debugPrint('send Data');
    if (kIsWeb) {
      _socket?.send([
        {event: jsonEncode(data)}
      ]);
    } else {
      _socket?.send([
        {event: data}
      ]);
    }
  }
}
