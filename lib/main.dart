import 'dart:async';
import 'package:covid_19_contact_tracing_app/widgets/dragSection.dart';
import 'package:covid_19_contact_tracing_app/widgets/pageButton.dart';
import 'package:covid_19_contact_tracing_app/utilities/contactTracingUtilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'pages/symptoms/symptomsSelection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if(FirebaseAuth.instance.currentUser == null) {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInAnonymously();
    print(userCredential.user.uid);
  }
  ContactTracingUtilities.init();
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
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Walkdown',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          SnappingSheet(
            sheetBelow: SnappingSheetContent(
              child: Container(
                color: Colors.white,
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  children: [
                    PageButton(
                      icon: Icons.thermostat_rounded,
                      pageName: 'Check Symptoms',
                      onPress: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SymptomsSelection())
                        );
                      },
                    ),
                  ],
                ),
              ),
              heightBehavior: SnappingSheetHeight.fixed(),
            ),
            grabbing: DragSection(),
            grabbingHeight: 100,
            initSnapPosition: SnapPosition(positionFactor: 0),
            snapPositions: [
              SnapPosition(
                positionFactor: 0,
                snappingDuration: Duration(milliseconds: 100)
              ),
              SnapPosition(
                  positionFactor: 0.5,
                  snappingDuration: Duration(milliseconds: 100)
              ),
            ],
          ),
        ],
      ),
    );
  }
}
