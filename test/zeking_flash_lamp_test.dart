import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zeking_flash_lamp/zeking_flash_lamp.dart';

void main() {
  const MethodChannel channel = MethodChannel('zeking_flash_lamp');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

//  test('getPlatformVersion', () async {
//    expect(await ZekingFlashLamp.platformVersion, '42');
//  });
}
