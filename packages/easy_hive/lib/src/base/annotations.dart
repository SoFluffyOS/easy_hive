import '../utils/constants.dart';

class EasyBoxClass {
  final bool isLazy;
  final bool isEncrypted;
  final String encryptionKeyName;
  final String boxKey;

  final String? generatedClassName;

  const EasyBoxClass({
    this.isLazy = false,
    this.isEncrypted = false,
    this.encryptionKeyName = kEasyBoxDefaultEncryptionKey,
    this.boxKey = kEasyBoxDefaultName,
    this.generatedClassName,
  });
}

class EasyBoxField {
  final Type? type;
  final dynamic defaultValue;

  const EasyBoxField([
    this.type,
    this.defaultValue,
  ]);
}
