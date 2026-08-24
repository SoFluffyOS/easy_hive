import 'package:easy_hive/easy_hive.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive_ce.dart';

mixin LazyMixin<T> on EasyBox<T> {
  @override
  bool get isLazy => true;

  @protected
  LazyBox<T> get _lazyBox {
    final result = baseBox;
    if (result == null) {
      throw Exception('[HiveBox] $boxKey is not initialized');
    }
    return result as LazyBox<T>;
  }

  @override
  Future<dynamic> get(dynamic key, {dynamic defaultValue}) async {
    if (key is Enum) {
      key = key.toString();
    }
    return await _lazyBox.get(key, defaultValue: defaultValue) ?? defaultValue;
  }
}
