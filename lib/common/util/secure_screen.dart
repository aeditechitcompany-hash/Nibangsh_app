import 'package:flutter/services.dart';

class SecureScreen {
  static const MethodChannel _channel =
      MethodChannel('secure_screen');

  static Future<void> enable() async {
    await _channel.invokeMethod('enableSecure');
  }

  static Future<void> disable() async {
    await _channel.invokeMethod('disableSecure');
  }
}