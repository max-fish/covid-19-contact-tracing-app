import 'dart:async';
import 'dart:collection';
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

  Future<List<CoronavirusDataModel>> covidData;

  Future<Map<String, dynamic>> coordinates;

  final Set<Circle> _circles = HashSet<Circle>();

  final Completer<GoogleMapController> _controller = Completer();

  int _circleIdCounter = 1;

  static const CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(51.5074, 0.1278),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    CoronavirusData.getUpperTierData().then((covidData) {
      AssetUtils.loadLocaAuthorityCoordinates().then((nameToCoordinates) {
        covidData.forEach((covidDataInArea) {
          final String areaName = covidDataInArea.areaName;
          print(areaName);
          final coordinates = nameToCoordinates[areaName];
          if(coordinates != null) {
            _setCircle(LatLng(coordinates['lat'], coordinates['long']), covidDataInArea.newCases);
          }
        });
        refreshWidget();
      });
    });
  }

  void refreshWidget() {
    setState(() {});
  }

  void _setCircle(LatLng point, int cases) {
    final _circleIdValue = 'circle_id_$_circleIdCounter';
    _circleIdCounter++;
    _circles.add(Circle(
      circleId: CircleId(_circleIdValue),
      center: point,
      radius: 25.0 * cases,
      fillColor: Colors.orange.withOpacity(0.5),
      strokeWidth: 1,
      strokeColor: Colors.orange,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      circles: _circles,
    );
  }
}
