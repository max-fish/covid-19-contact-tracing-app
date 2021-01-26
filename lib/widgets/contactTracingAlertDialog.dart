import '../utilities/userPreferences.dart';
import 'package:flutter/material.dart';

Future<void> showContactTracingAlertDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Contact Tracing'),
        content: const Text('Would you like contact tracing to be enabled?'),
        actions: [
          FlatButton(
            onPressed: () {
              UserPreferences.setContactTracingPreference(false);
              Navigator.pop(context);
            },
            child: const Text('Leave it off')),
          FlatButton(
            onPressed: () {
              UserPreferences.setContactTracingPreference(true);
              Navigator.pop(context);
            },
              child: const Text('Turn it on'))
        ],
      );
    }
  );
}