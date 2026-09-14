
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SecureScreen {
static const MethodChannel _channel =
MethodChannel('secure_screen');

static Future<void> enable() async {
try {
await _channel.invokeMethod('enable');
} catch (e) {
debugPrint('SecureScreen enable error: $e');
}
}

static Future<void> disable() async {
try {
await _channel.invokeMethod('disable');
} catch (e) {
debugPrint('SecureScreen disable error: $e');
}
}
}
