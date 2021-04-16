import 'dart:async';

import 'package:flutter/services.dart';

class D2uhf {
  static const MethodChannel _channel = const MethodChannel('d2uhf');

  static Future<int?> get readPower async {
    final int? power = await _channel.invokeMethod('getPower');
    return power;
  }

  static Future<String> get readTag async {
    final String tag = await _channel.invokeMethod('getTag');
    return tag;
  }

  static Future<int> writePower(int newPower) async {
    final int currentPower = await _channel
        .invokeMethod('setPower', <String, dynamic>{'newPower': newPower});
    return currentPower;
  }
}
