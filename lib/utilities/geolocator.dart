import 'LocationPermissionManager.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
class GeoLocator {
  static Future<Position> determinePosition(BuildContext context) async {
    final bool allowed = await LocationPermissionManager.checkPermissions(context);
    if(allowed) {
      return await Geolocator.getCurrentPosition();
    }
    else{
      return Future.value(null);
    }
  }
}
