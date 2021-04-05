import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

Future<FlutterDriver> setupAndGetDriver() async {
  final FlutterDriver driver = await FlutterDriver.connect();
  var connected = false;
  while (!connected) {
    try {
      await driver.waitUntilFirstFrameRasterized();
      connected = true;
    } catch (error) {}
  }
  return driver;
}

void main() {

  group('app', () {

    FlutterDriver flutterDriver;

    setUpAll(() async {
      flutterDriver = await setupAndGetDriver();
    });


    final textFinder = find.text('Getting COVID data...');

    test('starts to get covid data', () async {
      await flutterDriver.runUnsynchronized(() async {
        final stringOnScreen = await flutterDriver.getText(textFinder);
        expect(stringOnScreen, 'Getting COVID data...');
      });
    });

    tearDownAll(() async {
      if (flutterDriver != null) {
        flutterDriver.close();
      }
    });
  });
}