import 'package:flutter/foundation.dart';
import 'package:easy_hive/src/utils/constants.dart';
import 'package:easy_hive/src/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'base/base_easy_box.dart';

/// EasyBox is a wrapper for Hive Box.
/// It provides some useful features.
/// - Encryption: Use [EncryptionMixin] to enable encryption.
/// - Lazy loading: Use [LazyMixin] to enable lazy loading.
/// - Enum key support: Set [enumKeySupport] to true to enable enum key support.
/// - Listenable: Extends [RefreshableBox] instead of [EasyBox] to enable refreshable.
abstract class EasyBox<T> implements BaseEasyBox {
  @protected
  static bool enumKeySupport = true;

  /// Initialize the box.
  /// [enumKeySupport] is used to determine whether to convert enum keys to strings.
  /// If you are using enum keys, you must set this to true.
  /// Otherwise, it will throw an exception when you try to get the value.
  static Future<void> initialize({
    bool enumKeySupport = true,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();

    EasyBox.enumKeySupport = enumKeySupport;
  }

  String get boxKey;

  bool get isEncrypted => false;

  bool get isLazy => false;

  String get encryptionKeyName => kEasyBoxDefaultEncryptionKey;

  bool _isInitializing = false;

  bool get isInitialized => _box != null;

  BoxBase<T>? _box;

  @protected
  BoxBase<T>? get baseBox => _box;

  @protected
  Box<T> get box {
    final result = _box;
    if (result == null) {
      throw Exception('[HiveBox] $boxKey is not initialized');
    }
    return result as Box<T>;
  }

  @protected
  set box(BoxBase<T> box) {
    _box = box;
  }

  @override
  Future<void> close() async {
    await _box?.close();
    _box = null;
  }

  @override
  Future<void> init() async {
    if (isInitialized || _isInitializing) {
      return;
    }

    _isInitializing = true;

    if (!isEncrypted) {
      await openNormalBox();
      _isInitializing = false;
      return;
    }

    try {
      await openEncryptedBox();
    } catch (_) {
      printLog(
        '[EasyBox] Failed to open encrypted box $boxKey. Deleting...',
      );
      await Hive.deleteBoxFromDisk(boxKey);
      await openEncryptedBox();
    }

    _isInitializing = false;
  }

  @override
  dynamic get(dynamic key, {required dynamic defaultValue}) {
    if (key is Enum) {
      key = key.toString();
    }
    return box.get(
      key,
      defaultValue: defaultValue,
    );
  }

  @override
  Future<void> put(dynamic key, dynamic value) async {
    if (key is Enum) {
      key = key.toString();
    }
    return await box.put(key, value);
  }

  @override
  ValueListenable<void> listenTo<T>(List<T> keys) {
    if (T == Enum && enumKeySupport) {
      return this.box.listenable(
            keys: keys.map((e) => e.toString()).toList(),
          );
    }
    return this.box.listenable(
          keys: keys,
        );
  }

  @protected
  @override
  Future<void> openNormalBox() async {
    if (isLazy) {
      _box = await Hive.openLazyBox(boxKey);
    } else {
      _box = await Hive.openBox(boxKey);
    }
  }

  @protected
  @override
  Future<void> openEncryptedBox() async {}
}
