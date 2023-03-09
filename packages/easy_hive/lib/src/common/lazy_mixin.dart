import 'package:easy_hive/easy_hive.dart';
import 'package:hive/hive.dart';

mixin LazyMixin<T> on EasyBox<T> {
  @override
  bool get isLazy => true;

  LazyBox<T> get lazyBox {
    final result = baseBox;
    if (result == null) {
      throw Exception('[HiveBox] $boxKey is not initialized');
    }
    return result as LazyBox<T>;
  }
}
