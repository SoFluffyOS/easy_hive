import 'package:easy_hive/src/common/constants.dart';
import 'package:easy_hive/src/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class EasyBox<T> with BaseEncryption {
  String get boxKey;

  bool get isEncrypted => false;

  bool get isLazy => false;

  String get encryptionKeyName => kHiveBoxDefaultEncryptionKey;

  bool _isInitializing = false;

  bool get isInitialized => _box != null;

  BoxBase<T>? _box;

  @protected
  BoxBase<T>? get baseBox => _box;

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

  Future<void> dispose() async {
    await _box?.close();
    _box = null;
  }

  Future<void> init() async {
    if (isInitialized || _isInitializing) {
      return;
    }

    _isInitializing = true;

    if (!isEncrypted) {
      await _openNormalBox();
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

  @protected
  Future<void> _openNormalBox() async {
    if (isLazy) {
      _box = await Hive.openLazyBox(boxKey);
    } else {
      _box = await Hive.openBox(boxKey);
    }
  }
}

abstract class BaseEncryption {
  Future<void> openEncryptedBox() async {}
}
