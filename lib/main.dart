import 'package:covid_19_contact_tracing_app/dragSection.dart';
import 'package:covid_19_contact_tracing_app/pageButton.dart';
import 'package:covid_19_contact_tracing_app/settings.dart';
import 'package:covid_19_contact_tracing_app/symptoms/symptomsSelection.dart';
import 'package:covid_19_contact_tracing_app/utilities/contactTracingUtilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

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
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[SymptomsSelection(), Settings()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'settings')
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
