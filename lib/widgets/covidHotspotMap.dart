import 'dart:async';
import '../models/covidMarkerModel.dart';
import 'areaDescriptionTiles.dart';
import '../utilities/covidHotspotIconGenerator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CovidHotspotMap extends StatefulWidget {
  final LocationData location;
  final List<CovidMarkerModel> covidData;

  CovidHotspotMap({this.location, @required this.covidData});

  @override
  _CovidHotspotMapState createState() => _CovidHotspotMapState();
}

class _CovidHotspotMapState extends State<CovidHotspotMap> {
  Widget areaDescriptionTiles;

  Future<Map<String, dynamic>> coordinates;

  final Set<Marker> _markers = Set<Marker>();

  GoogleMapController googleMapController;

  final Completer<GoogleMapController> _controller = Completer();

  int _markerIdCounter = 1;

  static const CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(51.5074, 0.1278),
    zoom: 11,
  );

  Future<void> _setMarkers(BuildContext buildContext) async {
    for (CovidMarkerModel covidMarkerModel in widget.covidData) {
      final _markerIdValue = 'marker_id_$_markerIdCounter';
      _markerIdCounter++;
      final BitmapDescriptor hotspotIcon =
          await generateCovidHotspotIcon(covidMarkerModel.newCases * 2.0);
      final PageController pageController = PageController(
          initialPage: widget.covidData.indexOf(covidMarkerModel));
      _markers.add(Marker(
          markerId: MarkerId(_markerIdValue),
          icon: hotspotIcon,
          position:
              LatLng(covidMarkerModel.latitude, covidMarkerModel.longitude),
          onTap: () async {
            showBottomSheet(
                context: buildContext,
                builder: (BuildContext context) {
                  return AreaDescriptionTiles(
                      covidData: widget.covidData,
                      pageController: pageController,
                      googleMapController: googleMapController);
                });
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) async {
          googleMapController = controller;
          if (!_controller.isCompleted) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 10),
                        const Text('Adding hotspots...')
                      ])
                  );
                });
            await _setMarkers(context);
            Navigator.pop(context);
            setState(() {});
            _controller.complete(controller);
          }
        },
        markers: _markers);
  }
}
