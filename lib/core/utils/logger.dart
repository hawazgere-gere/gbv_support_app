import 'package:flutter/foundation.dart';

class Logger {
  static log(String message) {
    if (!kReleaseMode) {
      debugPrint('[LOG]: $message');
    }
  }
}
