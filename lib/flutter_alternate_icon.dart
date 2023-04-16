import 'dart:async';
import 'package:flutter/services.dart';

class FlutterAlternateIcon {
  static const methodChannel = MethodChannel('flutter_alternate_icon');

  static Future<bool> get supportsAlternateIcons async {
    return await methodChannel.invokeMethod('supportsAlternateIcons');
  }

  static Future<String?> getAlternateIconName() async {
    return await methodChannel.invokeMethod('getAlternateIconName');
  }

  static Future setAlternateIcon(String? iconName) async {
    await methodChannel.invokeMethod('setAlternateIconName', {
      'iconName': iconName,
    });
  }

  static Future<List<String>> getAlternateIconNames() async {
    final list = await methodChannel.invokeMethod('getAlternateIconNames') as List<Object?>?;
    return list?.map((e) => e as String).toList() ?? [];
  }
}