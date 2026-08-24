# 3.0.0 💥

Note (Android): `flutter_secure_storage` version 11.0.0 will remove some vulnerable cipher algorithm. Advising to upgrade `easy_hive_encryption` to 2.0.0 first so existing data will be migrated to use `AES_GCM_NoPadding`.

- ⬆️ Upgrade flutter_secure_storage: 11.0.0.

# 2.0.0

Note (Android): `flutter_secure_storage` version 11.0.0 will remove some vulnerable cipher algorithm. Advising to upgrade to this version first so existing data will be migrated to use `AES_GCM_NoPadding`.

- ⬆️ Updates minimum supported SDK version to Flutter 3.38/Dart 3.10.
- ✈️ Migrate from hive to hive_ce
- 🩹 Retry upon open encrypted box failure for iOS
- ⬆️ Upgrade flutter_secure_storage: 10.3.1.

# 1.2.1

- ⬆️ Upgrade `easy_hive` dependency to 1.2.0 for critical data loss fix.

# 1.2.0

- ⬆️ Upgrade flutter_secure_storage: ^9.2.2.
- 🔒️ Remove usage of AES/CBC/PKCS7Padding (vulnerable) cipher algorithm.

# 1.1.0

- ⬆️ Upgrade flutter_secure_storage: ^9.0.0. (breaking change for Windows)
- ⬆️ Bump Dart SDK constraint to >=2.19.0 <4.0.0.

- # 1.0.0+1

- 📝 Update documentation.

# 1.0.0

- 🎉 Initial release.
