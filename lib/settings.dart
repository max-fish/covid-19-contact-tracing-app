import 'package:covid_19_contact_tracing_app/sharedPreferences.dart';
import 'package:flutter/material.dart';

import 'utilities/contactTracingUtilities.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final bool gpsTracking = true;

  final bool locationSharing = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Tracing', style: Theme.of(context).textTheme.headline5,),
          SizedBox(height: 8,),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Contact Tracing', style: Theme.of(context).textTheme.bodyText2,),
                      FutureBuilder(
                        future: UserPreferences.getContactTracingPreference(),
                          builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.done) {
                          print(snapshot.data);
                          return Switch(value: snapshot.data ?? false,
                              onChanged: (bool shouldTrace) async {
                                  await ContactTracingUtilities.toggleContactTracing(
                                      context, shouldTrace);
                                  setState(() {});
                          });
                        }
                        else{
                          return Switch(value: false, onChanged: null);
                        }
                      }
                      ),
                    ],
                  ),
                ],
              ),
            ),),
          SizedBox(height: 36,),
          Text('Location', style: Theme.of(context).textTheme.headline5,),
          SizedBox(height: 8,),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Location Sharing', style: Theme.of(context).textTheme.bodyText2,),
                      Switch(
                        value: locationSharing,
                        onChanged: (bool value) {},
                      )],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('GPS Tracking', style: Theme.of(context).textTheme.bodyText2,),
                      Switch(
                        value: gpsTracking,
                        onChanged: (bool value) {},
                      )
                    ],
                  )
                ],
              ),
            ),),
        ],
      ),
    );
  }
}
