import 'models/covidMarkerModel.dart';
import 'models/coronavirusDataModel.dart';
import 'pages/interactions/interactions.dart';
import 'pages/test_result/testResult.dart';
import 'utilities/assetUtilities.dart';
import 'utilities/coronavirusData.dart';
import 'utilities/userPreferences.dart';
import 'widgets/covidHotspotMap.dart';
import 'widgets/dragSection.dart';
import 'widgets/pageButton.dart';
import 'utilities/contactTracingUtilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'pages/symptoms/symptomsSelection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (FirebaseAuth.instance.currentUser == null) {
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    print(userCredential.user.uid);
  }
  ContactTracingUtilities.init();
  await UserPreferences.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(bodyText2: TextStyle(fontSize: 16.0)),
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

  Future<List<CovidMarkerModel>> _getCovidData() async {
    final List<CovidMarkerModel> covidMarkerData = List<CovidMarkerModel>();
    final List<CoronavirusDataModel> upperTierCovidData =
    await CoronavirusData.getUpperTierData();
    final List<CoronavirusDataModel> lowerTierCovidData =
    await CoronavirusData.getLowerTierData();
    final nameToCoordinates = await AssetUtils.loadLocaAuthorityCoordinates();
    final List<CoronavirusDataModel> allTierCovidData = [
      ...upperTierCovidData,
      ...lowerTierCovidData
    ];
    for (CoronavirusDataModel covidDataInArea in allTierCovidData) {
      final String areaName = covidDataInArea.areaName;
      final coordinates = nameToCoordinates[areaName];
      if (coordinates != null && covidDataInArea.newCases != 0) {
        covidMarkerData.add(CovidMarkerModel(
            areaName: areaName,
            newCases: covidDataInArea.newCases,
            latitude: coordinates['lat'],
            longitude: coordinates['long']));
      }
    }
    return covidMarkerData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Walkdown',
      //     style: Theme.of(context)
      //         .textTheme
      //         .headline6
      //         .copyWith(color: Colors.white),
      //   ),
      // ),
      body: FutureBuilder<List<CovidMarkerModel>>(
        future: _getCovidData(),
        builder: (BuildContext context, AsyncSnapshot<List<CovidMarkerModel>> snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CovidHotspotMap(covidData: snapshot.data,),
                Align(
                  alignment: const Alignment(0, -0.85),
                  child: Container(
                    height: 50,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 10,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        const BorderRadius.all(Radius.elliptical(50, 50)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3))
                        ]),
                    child: const Align(
                        alignment: Alignment(-0.85, 0),
                        child: Text(
                          'Go somewhere',
                          style: TextStyle(color: Colors.blueGrey),
                        )),
                  ),
                ),
                SnappingSheet(
                  sheetBelow: SnappingSheetContent(
                    child: Container(
                      color: Colors.white,
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: [
                          PageButton(
                            icon: Icons.thermostat_rounded,
                            pageName: 'Check Symptoms',
                            onPress: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SymptomsSelection()));
                            },
                          ),
                          PageButton(
                              icon: Icons.input_rounded,
                              pageName: 'I am positive for COVID-19',
                              onPress: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TestResult()));
                              }),
                          PageButton(
                            icon: Icons.list_alt_rounded,
                            pageName: 'View Interactions',
                            onPress: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Interactions()));
                            },
                          )
                        ],
                      ),
                    ),
                    heightBehavior: const SnappingSheetHeight.fixed(),
                  ),
                  grabbing: DragSection(),
                  grabbingHeight: 100,
                  initSnapPosition: const SnapPosition(positionFactor: 0),
                  snapPositions: [
                    const SnapPosition(
                        positionFactor: 0,
                        snappingDuration: Duration(milliseconds: 100)),
                    const SnapPosition(
                        positionFactor: 0.5,
                        snappingDuration: Duration(milliseconds: 100)),
                  ],
                ),
              ],
            );
          } else {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 10),
                const Text('Getting COVID data...')
              ],
            ));
          }
        },
      ),
    );
  }
}
