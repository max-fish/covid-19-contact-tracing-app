import 'dart:async';
import 'dart:collection';
import '../utilities/covidHotspotIconGenerator.dart';
import '../utilities/assetUtilities.dart';
import '../models/coronavirusDataModel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../utilities/coronavirusData.dart';

class CovidHotspotMap extends StatefulWidget {
  final LocationData location;

  CovidHotspotMap({this.location});

  @override
  _CovidHotspotMapState createState() => _CovidHotspotMapState();
}

class _CovidHotspotMapState extends State<CovidHotspotMap> {

  List<CoronavirusDataModel> covidData;

  Future<Map<String, dynamic>> coordinates;

  Set<Marker> _markers;

  final Completer<GoogleMapController> _controller = Completer();

  int _markerIdCounter = 1;

  static const CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(51.5074, 0.1278),
    zoom: 11,
  );

  Future<Set<Marker>> _setMarkers() async {
    final Set<Marker> markers = HashSet<Marker>();
    final List<CoronavirusDataModel> upperTierCovidData =
    await CoronavirusData.getUpperTierData();
    final List<CoronavirusDataModel> lowerTierCovidData =
    await CoronavirusData.getLowerTierData();
    final nameToCoordinates = await AssetUtils.loadLocaAuthorityCoordinates();
    final List<CoronavirusDataModel> allTierCovidData = [
      ...upperTierCovidData,
      ...lowerTierCovidData
    ];
    covidData = allTierCovidData;
    for (CoronavirusDataModel covidDataInArea in allTierCovidData) {
      final String areaName = covidDataInArea.areaName;
      final coordinates = nameToCoordinates[areaName];
      if (coordinates != null && covidDataInArea.newCases != 0) {
        final _markerIdValue = 'marker_id_$_markerIdCounter';
        _markerIdCounter++;
        final BitmapDescriptor hotspotIcon = await generateCovidHotspotIcon(covidDataInArea.newCases * 2.0);
          markers.add(Marker(
            markerId: MarkerId(_markerIdValue),
            icon: hotspotIcon,
            position: LatLng(coordinates['lat'], coordinates['long']),
          ));
      }
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _setMarkers(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          _markers = snapshot.data;
          print(snapshot.data);
          return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: snapshot.data);
        } else {
          return const CircularProgressIndicator();
        }
      }
    );
  }
}
