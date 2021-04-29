import 'dart:async';

import 'package:flutter/services.dart';

class D2uhf {
  static const MethodChannel _channel = const MethodChannel('d2uhf');

  /// Use this for init device (return bool)
  static Future<bool?> get onInit async {
    final bool? success = await _channel.invokeMethod('onInit');
    return success;
  }

  /// Use this for uninit device (It is not yet clear whether this is necessary)
  static Future<bool?> get onUnInit async {
    final bool? success = await _channel.invokeMethod('onUnInit');
    return success;
  }

  /// Use this for get current power value (return int)
  static Future<int?> get getPower async {
    final int? power = await _channel.invokeMethod('getPower');
    return power;
  }

  /// Use this for write new power value (return bool)
  static Future<bool?> writePower(int newPower) async {
    final bool? isSuccess = await _channel
        .invokeMethod('setPower', <String, int>{'newPower': newPower});
    return isSuccess;
  }

  /// Use this for get current module temperature (return int)
  static Future<int?> get getTemperature async {
    final int? temperature = await _channel.invokeMethod('getTemperature');
    return temperature;
  }

  /// Use this for get current frequency region (return String)
  static Future<String?> get getFrequencyRegion async {
    final String? region = await _channel.invokeMethod('getFrequencyRegion');
    return region;
  }

  /// Use this for read tag ID from UHF tag (return String)
  static Future<String> get readTag async {
    final String tag = await _channel.invokeMethod('getTag');
    return tag;
  }
}
