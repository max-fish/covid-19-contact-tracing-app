import 'pages/notification_information/notificationInformation.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'messageHandler.dart';
import 'firebase/functionService.dart';
import 'firebase/messagingService.dart';
import 'models/covidMarkerModel.dart';
import 'models/coronavirusDataModel.dart';
import 'pages/about_page/aboutPage.dart';
import 'pages/interactions/interactions.dart';
import 'pages/positive_test/positiveTest.dart';
import 'utilities/assetUtilities.dart';
import 'utilities/coronavirusData.dart';
import 'utilities/userPreferences.dart';
import 'widgets/covidHotspotMap.dart';
import 'widgets/dragSection.dart';
import 'widgets/pageButton.dart';
import 'utilities/contactTracingUtilities.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'pages/symptoms/symptomsSelection.dart';
import 'firebase/authService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AuthService.signInAnonIfNew();
  ContactTracingUtilities.init();
  await UserPreferences.init();
  await MessagingService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FunctionService.init(context);
    if (UserPreferences.getContactTracingPreference().getValue()) {
      ContactTracingUtilities.publishNotSick(context);
    }
    return MaterialApp(
        title: 'Walkdown',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(bodyText2: TextStyle(fontSize: 16.0)),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MessageHandler(child: MyHomePage()));
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
    final nameToCoordinates = await AssetUtils.loadLocaAuthorityCoordinates();
    final List<CoronavirusDataModel> allTierCovidData =
        await CoronavirusData.getAllTierCovidData();
    for (CoronavirusDataModel covidDataInArea in allTierCovidData) {
      final String areaName = covidDataInArea.areaName;
      final coordinates = nameToCoordinates[areaName];
      if (coordinates != null && covidDataInArea.newCases != 0) {
        covidMarkerData.add(CovidMarkerModel(
            areaName: areaName,
            areaCode: covidDataInArea.areaCode,
            newCases: covidDataInArea.newCases,
            yesterdayCases: covidDataInArea.yesterdayCases,
            latitude: coordinates['lat'],
            longitude: coordinates['long']));
      }
    }
    return covidMarkerData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CovidMarkerModel>>(
        future: _getCovidData(),
        builder: (BuildContext context,
            AsyncSnapshot<List<CovidMarkerModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height - 95,
                    child: CovidHotspotMap(
                      covidData: snapshot.data,
                    )),
                SnappingSheet(
                  sheetBelow: SnappingSheetContent(
                    child: Container(
                      color: Colors.white,
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: [
                          PreferenceBuilder<bool>(
                              preference:
                                  UserPreferences.getContactTracingPreference(),
                              builder: (BuildContext context,
                                  bool contactTracingPreference) {
                                return PageButton(
                                    icon: Icons.thermostat_rounded,
                                    pageName: 'Check Symptoms',
                                    onPress: contactTracingPreference
                                        ? () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SymptomsSelection()))
                                        : null);
                              }),
                          PreferenceBuilder<bool>(
                              preference:
                                  UserPreferences.getContactTracingPreference(),
                              builder: (BuildContext context,
                                  bool contactTracingPreference) {
                                return PageButton(
                                    icon: Icons.input_rounded,
                                    pageName: 'I am positive for COVID-19',
                                    onPress: contactTracingPreference
                                        ? () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TestResult()))
                                        : null);
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
                          ),
                          PageButton(
                            icon: Icons.notifications_active_rounded,
                            pageName:
                                'I got an exposure notification. What should I do?',
                            onPress: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationInformation()));
                            },
                          ),
                          PageButton(
                            icon: Icons.info_outline_rounded,
                            pageName: 'About this app',
                            onPress: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AboutPage()));
                            },
                          ),
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
            return Center(
                child: Column(
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
