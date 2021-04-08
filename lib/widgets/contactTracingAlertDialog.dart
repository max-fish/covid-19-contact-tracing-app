import '../utilities/contactTracingUtilities.dart';
import 'package:flutter/material.dart';

//function that displays a box that queries the user for their contact tracing preference
Future<void> showContactTracingAlertDialog(BuildContext dragSectionContext) {
  return showDialog<void>(
    context: dragSectionContext,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Contact Tracing'),
        content: const Text('Would you like contact tracing to be enabled?'),
        actions: [
          FlatButton(
            onPressed: () {
              //ensure contact tracing is off
              ContactTracingUtilities.toggleContactTracing(dragSectionContext, false);
              Navigator.pop(context);
            },
            child: const Text('Leave it off')),
          FlatButton(
            onPressed: () {
              //turns contact tracing on
              ContactTracingUtilities.toggleContactTracing(dragSectionContext, true);
              Navigator.pop(context);
            },
              child: const Text('Turn it on'))
        ],
      );
    }
  );
}