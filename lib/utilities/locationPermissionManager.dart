import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

//Utility class that holds a function to check location access permissions
class LocationPermissionManager {
  static Future<bool> checkPermissions(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    // uses geolocator library
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      //ask user to enable location services
      await showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('Location Services'),
              content: const Text(
                  'Location services are disabled. Please enable them in location settings and restart the app.'),
              actions: [
                FlatButton(
                  // uses geolocator libary
                    onPressed: () => Geolocator.openLocationSettings(),
                    child: const Text('Open location settings')),
                FlatButton(
                    onPressed: () async {
                      serviceEnabled =
                      //uses geolocator library
                      await Geolocator.isLocationServiceEnabled();
                      Navigator.pop(context);
                    },
                    child: const Text('Ok'))
              ],
            );
          });
      
      if (serviceEnabled == false) {
        //deny permission if the user does not enable location services
        return false;
      }
    }

      //uses geolocator library
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        //uses geolocator library
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          // the app can no longer ask for permission
          // tells user how to enable location permissions manually
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
                          //uses geolocator library
                          permission = await Geolocator.checkPermission();
                          if (permission != LocationPermission.deniedForever) {
                            //uses geolocator library
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
                    //uses geolocator library
                    FlatButton(onPressed: () => Geolocator.openAppSettings(),
                        child: const Text('Open app settings'))
                  ],
                );
              });
          //resulting permission from the alert dialog
          return permissionResult;
        }

        if (permission == LocationPermission.denied) {
          // ensure the user wants to deny location permissions
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
                          //uses geolocator.library
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
          //resulting permission from the alert dialog
          return permissionResult;
        }
      }
      //deny permission
      else if(permission == LocationPermission.deniedForever){
        return false;
      }
      //allow to access location
      return true;
    }
}