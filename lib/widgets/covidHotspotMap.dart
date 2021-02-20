import 'dart:async';
import 'package:flutter/scheduler.dart';

import '../models/covidMarkerModel.dart';
import 'areaDescriptionTiles.dart';
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
  final List<CovidMarkerModel> covidMarkerData = List<CovidMarkerModel>();

  Widget areaDescriptionTiles;

  PageController pageController = PageController();

  Future<Map<String, dynamic>> coordinates;

  final Set<Marker> _markers = Set<Marker>();

  GoogleMapController googleMapController;

  final Completer<GoogleMapController> _controller = Completer();

  int _markerIdCounter = 1;

  static const CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(51.5074, 0.1278),
    zoom: 11,
  );

  Future<void> _getCovidData() async {
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
  }

  Future<void> _setMarkers(BuildContext buildContext) async {
    areaDescriptionTiles = AreaDescriptionTiles(
        covidData: covidMarkerData,
        pageController: pageController,
        googleMapController: googleMapController);
    for (CovidMarkerModel covidMarkerModel in covidMarkerData) {
      final _markerIdValue = 'marker_id_$_markerIdCounter';
      _markerIdCounter++;
      final BitmapDescriptor hotspotIcon =
          await generateCovidHotspotIcon(covidMarkerModel.newCases * 2.0);
      _markers.add(Marker(
          markerId: MarkerId(_markerIdValue),
          icon: hotspotIcon,
          position:
              LatLng(covidMarkerModel.latitude, covidMarkerModel.longitude),
          onTap: () async {
            showBottomSheet(
                context: buildContext,
                builder: (BuildContext context) {
                  return areaDescriptionTiles;
                });
            await Future.delayed(const Duration(milliseconds: 100));
            pageController
                .jumpToPage(covidMarkerData.indexOf(covidMarkerModel));
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getCovidData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) async {
                    googleMapController = controller;
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        child:
                        const Center(child: CircularProgressIndicator()));
                    await _setMarkers(context);
                    Navigator.pop(context);
                    _controller.complete(controller);
                },
                markers: _markers);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
