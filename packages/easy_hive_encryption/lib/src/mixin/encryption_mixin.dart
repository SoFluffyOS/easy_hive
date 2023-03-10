// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:easy_hive/easy_hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

mixin EncryptionMixin<T> on EasyBox<T> {
  @override
  bool get isEncrypted => true;

  @override
  Future<void> openEncryptedBox() async {
    const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
        resetOnError: true,
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
  }
}
