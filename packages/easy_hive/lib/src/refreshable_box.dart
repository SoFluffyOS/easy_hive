import 'package:easy_hive/easy_hive.dart';
import 'package:flutter/foundation.dart';

abstract class RefreshableBox<T> extends EasyBox<T> with ChangeNotifier {
  @override
  Future<void> put(dynamic key, dynamic value) async {
    await super.put(key, value);
    notifyListeners();
  }
}
