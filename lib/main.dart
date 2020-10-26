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

  void toggleScanning(value) {
    if(value){
      _subscribe();
    }
    else{
      _unsubscribe();
    }
    setState(() {
      scanning = !scanning;
    });
  }

  void toggleBackgroundScanning(value){
    if(value){
      _backgroundSubscribe();
    }
    else{
      _backgroundUnsubscribe();
    }
    setState(() {
      backgroundScanning = !backgroundScanning;
    });
  }

  Future<void> _subscribe() async {
    try{
      await platform.invokeMethod('subscribe');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _backgroundSubscribe() async {
    try{
      await platform.invokeMethod('backgroundSubscribe');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _unsubscribe() async {
    try{
      await platform.invokeMethod('unsubscribe');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _backgroundUnsubscribe() async {
    try{
      await platform.invokeMethod('backgroundUnsubscribe');
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
                Switch(value: scanning, onChanged: toggleScanning),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Scan while app is not running'),
                Switch(value: backgroundScanning, onChanged: toggleBackgroundScanning,)
              ],
            )
          ],
        ),
      ),
    );
  }
}
