import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

/// 获取设备标识
class DeviceIdentity {
  /// channel
  static const MethodChannel _channel = MethodChannel('device_identity');

  /// 判断是否是安卓平台
  static bool get isAndroid {
    return Platform.isAndroid;
  }

  /// 在`Application#onCreate`里初始化，注意APP合规性，若最终用户未同意隐私政策则不要调用
  static Future<void> register() async {
    if (isAndroid) {
      await _channel.invokeMethod('register');
    }
  }

  /// 获取安卓ID，可能为空
  static Future<String> get androidId async {
    if (isAndroid) {
      final String androidId = await _channel.invokeMethod('getAndroidID');
      return androidId;
    }

    return "";
  }

  /// 获取IMEI，只支持Android 10之前的系统，需要READ_PHONE_STATE权限，可能为空
  static Future<String> get imei async {
    if (isAndroid) {
      final String imei = await _channel.invokeMethod('getIMEI');
      return imei;
    }

    return "";
  }

  /// 获取OAID/AAID，可能为空
  static Future<String> get oaid async {
    if (isAndroid) {
      final String oaid = await _channel.invokeMethod('getOAID');
      return oaid;
    }

    return "";
  }

  /// 获取UA
  static Future<String> get ua async {
    if (isAndroid) {
      final String ua = await _channel.invokeMethod('getUA');
      return ua;
    }
    if (Platform.isIOS) {
      final String ua = await _channel.invokeMethod('getUA');
      return ua;
    }

    return "";
  }

  /// 获取IDFA，可能为空
  static Future<String> get idfa async {
    if (Platform.isIOS) {
      final String idfa = await _channel.invokeMethod('getIDFA');
      return idfa;
    }

    return "";
  }

  /// 获取Mac地址，可能为空
  static Future<String> get mac async {
    if (isAndroid) {
      final String mac = await _channel.invokeMethod('getMac');
      return mac;
    }

    return "";
  }
}
