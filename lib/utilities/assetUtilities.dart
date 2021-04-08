import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

// helper class for retrieving assets
class AssetUtils {
  //retrieve local authority coordinates file
  static Future<Map<String, dynamic>> loadLocalAuthorityCoordinates() async {
    final String coordinates = await rootBundle.loadString('assets/local_authority_coordinates.json');
    return jsonDecode(coordinates);
  }
}
