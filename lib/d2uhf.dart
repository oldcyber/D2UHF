import 'dart:async';

import 'package:flutter/services.dart';

class D2uhf {
  static const MethodChannel _channel = const MethodChannel('d2uhf');
/// Use this for get current power value
  static Future<int?> get readPower async {
    final int? power = await _channel.invokeMethod('getPower');
    return power;
  }
/// Use this for read tag ID from UHF tag
  static Future<String> get readTag async {
    final String tag = await _channel.invokeMethod('getTag');
    return tag;
  }
/// Use this for write new power value
  static Future<int> writePower(int newPower) async {
    final int currentPower = await _channel
        .invokeMethod('setPower', <String, dynamic>{'newPower': newPower});
    return currentPower;
  }
}
