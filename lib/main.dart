import 'widgets/contactTracingBottomSheet.dart';
import 'messageHandler.dart';
import 'firebase/functionService.dart';
import 'firebase/messagingService.dart';
import 'models/covidMarkerModel.dart';
import 'models/coronavirusDataModel.dart';
import 'utilities/assetUtilities.dart';
import 'data_retriever/coronavirusData.dart';
import 'utilities/userPreferences.dart';
import 'widgets/covidHotspotMap.dart';
import 'utilities/contactTracingUtilities.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase/authService.dart';

//main entry point for app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize connection with firebase
  //from firebase_core library
  await Firebase.initializeApp();
  // sign in user if app is launched for the first time
  await AuthService.signInAnonIfNew();
  // set up method channel connection
  ContactTracingUtilities.init();
  // retrieve user preference object
  await UserPreferences.init();
  // retrieve messaging token
  await MessagingService.init();
  //initialize the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // set up listener for cloud messages
    FunctionService.init(context);
    // start publishing not sick signal if user allows contact tracing
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

    //get name to local authority coordinates file
    final List<CovidMarkerModel> covidMarkerData = List<CovidMarkerModel>();
    final nameToCoordinates = await AssetUtils.loadLocalAuthorityCoordinates();

    //get covid data from uk gov api
    final List<CoronavirusDataModel> allTierCovidData =
        await CoronavirusData.getAllTierCovidData();

    //convert json to value object
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
    //main layout of app
    return Scaffold(
      body: FutureBuilder<List<CovidMarkerModel>>(
        future: _getCovidData(),
        builder: (BuildContext context,
            AsyncSnapshot<List<CovidMarkerModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //when covid data is done loading, show app contents
            return Stack(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height - 95,
                    child: CovidHotspotMap(
                      covidData: snapshot.data,
                    )),
                ContactTracingBottomSheet()
              ],
            );
          } else {
            //display loading screen
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
