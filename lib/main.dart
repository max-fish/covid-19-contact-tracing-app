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
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool scanning = true;
  bool backgroundScanning = true;
  static const platform = const MethodChannel('nearby-message-api');

  Future<void> _toggleSubscribe(bool shouldScan) async {
    try {
      await platform.invokeMethod('toggleSubscribe', <String, bool>{
        'shouldScan': shouldScan
      });
      setState(() {
        scanning = shouldScan;
      });
    } on PlatformException catch (e) {
      print(e);
    }
}

  Future<void> _toggleBackgroundSubscribe(bool shouldBackgroundScan) async {
    print(shouldBackgroundScan);
    try{
      await platform.invokeMethod('toggleBackgroundSubscribe', <String, bool>{
          'shouldBackgroundScan': shouldBackgroundScan
      });
      setState(() {
        backgroundScanning = shouldBackgroundScan;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Scan when app is running'),
                Switch(value: scanning, onChanged: _toggleSubscribe),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Scan while app is not running'),
                Switch(value: backgroundScanning, onChanged: _toggleBackgroundSubscribe,)
              ],
            )
          ],
        ),
      ),
    );
  }
}
