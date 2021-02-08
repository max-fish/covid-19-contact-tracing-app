import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AssetUtils {
  static Future<Map<String, dynamic>> loadLocaAuthorityCoordinates() async {
    final String coordinates = await rootBundle.loadString('assets/local_authority_coordinates.json');
    return jsonDecode(coordinates);
  }
}
