import 'package:flutter/foundation.dart';

abstract class BaseEasyBox {
  Future<void> init();

  Future<void> close();

  dynamic get(dynamic key, {required dynamic defaultValue});

  Future<void> put(dynamic key, dynamic value);

  ValueListenable<void> listenTo<T>(List<T> keys);

  @protected
  Future<void> openNormalBox();

  @protected
  Future<void> openEncryptedBox();
}
