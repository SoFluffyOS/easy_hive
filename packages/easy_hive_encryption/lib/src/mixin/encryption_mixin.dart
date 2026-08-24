// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer' as dev;

import 'package:easy_hive/easy_hive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive_ce.dart';

mixin EncryptionMixin<T> on EasyBox<T> {
  static const Duration _retryDelayDuration = Duration(seconds: 1);

  @override
  bool get isEncrypted => true;

  @override
  Future<void> openEncryptedBox() async {
    try {
      const secureStorage = FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
          resetOnError: true,
          keyCipherAlgorithm:
              KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
          storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
        ),
      );
      var key = await secureStorage.read(key: encryptionKeyName);
      if (key == null || key.isEmpty) {
        key = base64UrlEncode(Hive.generateSecureKey());
        await secureStorage.write(
          key: encryptionKeyName,
          value: key,
        );
      }
      final encryptionKey = base64Url.decode(key);

      if (isLazy) {
        box = await Hive.openLazyBox(
          boxKey,
          encryptionCipher: HiveAesCipher(encryptionKey),
        );
      } else {
        box = await Hive.openBox(
          boxKey,
          encryptionCipher: HiveAesCipher(encryptionKey),
        );
      }
    } catch (err, trace) {
      if (kDebugMode) {
        dev.log(
          '$err',
          name: 'EncryptionMixin<${T.runtimeType}>',
          stackTrace: trace,
        );
      }
      // Retry to prevent failure when iOS is in lockscreen.
      await Future.delayed(_retryDelayDuration);
      await openEncryptedBox();
    }
  }
}
