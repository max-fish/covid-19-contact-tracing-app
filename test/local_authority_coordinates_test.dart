import 'package:covid_19_contact_tracing_app/utilities/assetUtilities.dart';
import 'package:flutter_test/flutter_test.dart';

void main () {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('local authority coordinates are stored on device', () async {
    final coordinates = await AssetUtils.loadLocalAuthorityCoordinates();

    expect(coordinates.isNotEmpty, true);
    expect(coordinates.keys.first, isInstanceOf<String>());
    expect(coordinates.values.first, isInstanceOf<dynamic>());
  });
}