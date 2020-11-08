import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(bodyText2: TextStyle(fontSize: 16.0)),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Settings', style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),),
          ),
          body: MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool scanning = true;
  bool backgroundScanning = true;
  bool gpsTracking = true;
  bool locationSharing = true;
  static const platform = const MethodChannel('nearby-message-api');

  static Future<void> mediumImpact() async {
    await SystemChannels.platform.invokeMethod<void>(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.mediumImpact',
    );
  }

  Future<void> _toggleSubscribe(bool shouldScan) async {
    try {
      await platform.invokeMethod(
          'toggleSubscribe', <String, bool>{'shouldScan': shouldScan});
      setState(() {
        scanning = shouldScan;
      });
      if (shouldScan) {
        final snackBar = SnackBar(
          content: Text(
            'BLE Scanning Enabled',
            style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
        );
        Scaffold.of(context).showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(
          content: Text(
              'BLE Scanning Disabled (You will not be alerted of possible exposure when using the app)',
              style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white)),
          behavior: SnackBarBehavior.floating,
        );
        Scaffold.of(context).showSnackBar(snackBar);
      }
      await mediumImpact();
    } on PlatformException catch (e) {
      final snackBar = SnackBar(
        content: Text(
          e.message,
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _toggleBackgroundSubscribe(bool shouldBackgroundScan) async {
    print(shouldBackgroundScan);
    try {
      await platform.invokeMethod('toggleBackgroundSubscribe',
          <String, bool>{'shouldBackgroundScan': shouldBackgroundScan});
      setState(() {
        backgroundScanning = shouldBackgroundScan;
      });
      if (shouldBackgroundScan) {
        final snackBar = SnackBar(
            content: Text('Background Scanning Enabled'),
            backgroundColor: Colors.green);
        Scaffold.of(context).showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(
          content: Text('Background Scanning Disabled'),
          backgroundColor: Colors.green,
        );
        Scaffold.of(context).showSnackBar(snackBar);
      }
      await mediumImpact();
    } on PlatformException catch (e) {
      final snackBar = SnackBar(
        content: Text(e.message),
        backgroundColor: Colors.red,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

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
                    Text('Scan while app is running', style: Theme.of(context).textTheme.bodyText2,),
                    Switch(value: scanning, onChanged: _toggleSubscribe),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Scan while app is not running'),
                    Switch(
                      value: backgroundScanning,
                      onChanged: _toggleBackgroundSubscribe,
                    )
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
