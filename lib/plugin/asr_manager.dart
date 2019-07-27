import 'package:flutter/services.dart';

class AsrManager {
  static const MethodChannel _channel = const MethodChannel('asr_plugin');

  /// 开始录音
  static Future<String> start({Map params}) async {
    return _channel.invokeMethod('start', params ?? {});
  }

  /// 结束录音
  static Future<String> stop() async {
    return _channel.invokeMethod('stop');
  }

  /// 取消录音
  static Future<String> cancel() async {
    return _channel.invokeMethod('cancel');
  }
}
