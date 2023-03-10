import 'package:flutter/foundation.dart';

void printLog(dynamic message) {
  if (kDebugMode) {
    debugPrint('💬 $message');
  }
}

void printTest(dynamic message) {
  if (kDebugMode) {
    debugPrint('✅ $message');
  }
}

void printError(dynamic err, dynamic trace) {
  if (kDebugMode) {
    debugPrint('🐞 $err');
    if (trace != null) {
      debugPrint('$trace');
    }
  }
}
