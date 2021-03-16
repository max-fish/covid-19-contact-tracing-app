import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionManager {
  static Future<bool> checkPermissions(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('Location Services'),
              content: const Text(
                  'Location services are disabled. Please enable them in location settings and restart the app.'),
              actions: [
                FlatButton(
                    onPressed: () => Geolocator.openLocationSettings(),
                    child: const Text('Open location settings')),
                FlatButton(
                    onPressed: () async {
                      serviceEnabled =
                      await Geolocator.isLocationServiceEnabled();
                      Navigator.pop(context);
                    },
                    child: const Text('Ok'))
              ],
            );
          });
      if (serviceEnabled == false) {
        return false;
      }
    }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          // Permissions are denied forever, handle appropriately.
          final bool permissionResult = await showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: const Text('Location Permissions'),
                  content: const Text(
                      'Unfortunately, routes cannot be shown without your permission to access your location. You will need to enable location permissions in app settings.'),
                  actions: [
                    FlatButton(
                        onPressed: () async {
                          permission = await Geolocator.checkPermission();
                          if (permission != LocationPermission.deniedForever) {
                            permission = await Geolocator.requestPermission();
                            Navigator.pop(
                                context, permission != LocationPermission
                                .deniedForever &&
                                permission != LocationPermission.denied);
                          }
                          else {
                            Navigator.pop(context, false);
                          }
                        },
                        child: const Text('Ok')),
                    FlatButton(onPressed: () => Geolocator.openAppSettings(),
                        child: const Text('Open app settings'))
                  ],
                );
              });
          return permissionResult;
        }

        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          final bool permissionResult = await showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: const Text('Location Permissions'),
                  content: const Text(
                      'Unfortunately, routes cannot be shown without your permission to access your location'),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Ok')),
                    FlatButton(
                        onPressed: () async {
                          permission = await Geolocator.requestPermission();
                          Navigator.pop(context,
                              permission != LocationPermission.denied &&
                                  permission !=
                                      LocationPermission.deniedForever);
                        },
                        child: const Text('Allow location permissions'))
                  ],
                );
              });
          return permissionResult;
        }
      }
      else if(permission == LocationPermission.deniedForever){
        return false;
      }
      return true;
    }
}