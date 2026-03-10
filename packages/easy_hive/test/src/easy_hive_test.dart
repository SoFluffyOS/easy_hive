import 'package:easy_hive/src/easy_box.dart';
import 'package:flutter_test/flutter_test.dart';

class MockEasyBox extends EasyBox<dynamic> {
  @override
  String get boxKey => 'mock_box';

  @override
  bool get isEncrypted => true;

  @override
  Future<void> openEncryptedBox() async {
    throw Exception('Failed to open encrypted box');
  }

  @override
  Future<void> openNormalBox() async {}
}

void main() {
  group('EasyBox', () {
    test('init() should propagate exceptions from openEncryptedBox', () async {
      final box = MockEasyBox();
      expect(() => box.init(), throwsException);
    });
  });
}
