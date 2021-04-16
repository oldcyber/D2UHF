import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:d2uhf/d2uhf.dart';

void main() {
  const MethodChannel channel = MethodChannel('d2uhf');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getTag', () async {
    expect(await D2uhf.readTag, '42');
  });
}
