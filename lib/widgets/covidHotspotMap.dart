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
  BitmapDescriptor icon;

  List<CoronavirusDataModel> covidData;

  Future<Map<String, dynamic>> coordinates;

  final Set<Marker> _markers = HashSet<Marker>();

  final Completer<GoogleMapController> _controller = Completer();

  int _markerIdCounter = 1;

  static const CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(51.5074, 0.1278),
    zoom: 11,
  );

  @override
  void initState() {
    super.initState();
    CoronavirusData.getUpperTierData().then((upperTierCovidData) {
      CoronavirusData.getLowerTierData().then((lowerTierCovidData) {
        AssetUtils.loadLocaAuthorityCoordinates().then((nameToCoordinates) {
          final List<CoronavirusDataModel> allTierCovidData = [
            ...upperTierCovidData,
            ...lowerTierCovidData
          ];
          covidData = allTierCovidData;
          allTierCovidData.forEach((covidDataInArea) {
            final String areaName = covidDataInArea.areaName;
            final coordinates = nameToCoordinates[areaName];
            if (coordinates != null && covidDataInArea.newCases != 0) {
              _setMarker(LatLng(coordinates['lat'], coordinates['long']),
                  covidDataInArea);
            }
          });
        });
      });
    });
  }

  void refreshWidget() {
    setState(() {});
  }

  void _setMarker(LatLng point, CoronavirusDataModel covidData) {
    final _markerIdValue = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    generateCovidHotspotIcon(covidData.newCases * 2.0).then((hotspotIcon) {
      setState(() {
        _markers.add(Marker(
          markerId: MarkerId(_markerIdValue),
          icon: hotspotIcon,
          position: point,
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: _markers,
    );
  }
}
