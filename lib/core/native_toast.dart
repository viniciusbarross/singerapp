import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

enum ToastDuration {
  short,
  long;

  String get nativeValue {
    switch (this) {
      case ToastDuration.short:
        return "short";
      case ToastDuration.long:
        return "long";
    }
  }
}

class NativeToast {
  static const _platform = MethodChannel('com.example.app/toast');

  static Future<void> show(String message,
      {ToastDuration duration = ToastDuration.short}) async {
    try {
      await _platform.invokeMethod('showToast', {
        "message": message,
        "length": duration.nativeValue,
      });
    } on PlatformException catch (e) {
      debugPrint("Erro ao exibir toast: ${e.message}");
    }
  }
}
