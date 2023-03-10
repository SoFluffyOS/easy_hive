import 'package:easy_hive/easy_hive.dart';
import 'package:flutter/foundation.dart';

extension EasyBoxListExtension on List<EasyBox> {
  Future<void> initAll() async {
    for (final box in this) {
      await box.init();
    }
  }
}

extension EasyBoxKeysExtension on List<Enum> {
  ValueListenable<void> of(EasyBox box) {
    return box.listenTo(this);
  }
}
