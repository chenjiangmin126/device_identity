import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:device_identity/device_identity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    register();
  }

  /// 同意协议时调用
  Future<void> register() async {
    await DeviceIdentity.register();
  }

  /// 获取AndroidId
  Future<void> getAndroidId() async {
    String androidId = await DeviceIdentity.androidId;
    if (kDebugMode) {
      print("getAndroidId：$androidId");
    }
  }

  /// 获取imei
  Future<void> getImei() async {
    String imei = await DeviceIdentity.imei;
    if (kDebugMode) {
      print("getImei：$imei");
    }
  }

  /// 获取oaid
  Future<void> getOaid() async {
    String oaid = await DeviceIdentity.oaid;
    if (kDebugMode) {
      print("getOaid：$oaid");
    }
  }

  /// 获取ua
  Future<void> getUa() async {
    String ua = await DeviceIdentity.ua;
    if (kDebugMode) {
      print("getUa：$ua");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(onPressed: getAndroidId, child: const Text("获取AndroidId")),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(onPressed: getImei, child: const Text("获取imei")),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(onPressed: getOaid, child: const Text("获取oaid")),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(onPressed: getUa, child: const Text("获取ua")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
