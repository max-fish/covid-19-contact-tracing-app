import 'locationPermissionManager.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// Utility class that holds a method for determining the position of the device
class GeoLocator {
  // Determine the current position of the device.
  // When the location services are not enabled or permissions
  // are denied the function will return null.
  static Future<Position> determinePosition(BuildContext context) async {
    final bool allowed = await LocationPermissionManager.checkPermissions(context);
    if(allowed) {
      //uses geolocator library
      return await Geolocator.getCurrentPosition();
    }
    else{
      return Future.value(null);
    }
  }
}
