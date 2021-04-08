import 'dart:async';
import 'dart:io';
import 'searchBar.dart';

import '../utilities/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';


import '../models/covidMarkerModel.dart';
import 'areaDescriptionTiles.dart';
import '../utilities/covidHotspotIconGenerator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Map UI widget
class CovidHotspotMap extends StatefulWidget {
  final List<CovidMarkerModel> covidData;

  CovidHotspotMap({@required this.covidData});

  @override
  _CovidHotspotMapState createState() => _CovidHotspotMapState();
}

class _CovidHotspotMapState extends State<CovidHotspotMap> {
  static final String GOOGLE_API_KEY = Platform.isAndroid
      ? 'AIzaSyAFoRipVavXiM6xJauP0GmT9CodLLrvjcY'
      : 'AIzaSyBEg5Tu1h46jO7sStSmdGwwuBMZO5PSz48';

  bool loading = true;

  final Set<Marker> _markers = Set<Marker>();

  //uses google_maps_flutter library
  final Set<Polyline> _polylines = Set<Polyline>();

  //uses flutter_polyine_points library
  PolylinePoints polylinePoints = PolylinePoints();

  //uses google_maps_flutter library
  GoogleMapController googleMapController;

  final Completer<GoogleMapController> _controller = Completer();

  int _markerIdCounter = 1;

  //uses google_maps_flutter library
  static const CameraPosition _UK = const CameraPosition(
    target: LatLng(54.65478120656813, -3.1891666855373746),
    zoom: 5.7,
  );

  //converts each covid marker data model into a marker UI object
  Future<void> _setMarkers(BuildContext buildContext) async {
    for (CovidMarkerModel covidMarkerModel in widget.covidData) {
      final _markerIdValue = 'marker_id_$_markerIdCounter';
      _markerIdCounter++;
      //generate icon with size based on number of cases
      final BitmapDescriptor hotspotIcon =
          await CovidHotspotIconGenerator.getCovidHotpostIcon(
              covidMarkerModel.newCases * 2);
      final PageController pageController = PageController(
          initialPage: widget.covidData.indexOf(covidMarkerModel));

      //add marker to map
      _markers.add(Marker(
          markerId: MarkerId(_markerIdValue),
          icon: hotspotIcon,
          position:
              LatLng(covidMarkerModel.latitude, covidMarkerModel.longitude),
          onTap: () async {
            //connect map marker with data visualization
            showBottomSheet(
                context: buildContext,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return AreaDescriptionTiles(
                      covidData: widget.covidData,
                      pageController: pageController,
                      googleMapController: googleMapController);
                });
          }));
    }
  }

  // make the map show the full route on the screen
  // Position object is from geolocator library
  void moveCameraForRoute(Position currentPosition, PointLatLng latLng) {
    final double southwestLatitude = currentPosition.latitude <= latLng.latitude ? currentPosition.latitude : latLng.latitude;

    final double southwestLongitude = currentPosition.longitude <= latLng.longitude ? currentPosition.longitude : latLng.longitude;

    final double northeastLatitude = currentPosition.latitude <= latLng.latitude ? latLng.latitude : currentPosition.latitude;

    final double northeastLongitude = currentPosition.longitude <= latLng.longitude ? latLng.longitude : currentPosition.longitude;

    //uses flutter_polyline_points library
    googleMapController.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(southwestLatitude, southwestLongitude),
          northeast: LatLng(northeastLatitude, northeastLongitude),
        ), 50));
  }

  // plot route onto the map
  void showRoute(PointLatLng latLng) async {
    if (_polylines.isNotEmpty) {
      _polylines.clear();
    }

    //get current location of device
    final Position currentPosition =
    await GeoLocator.determinePosition(context);
    if(currentPosition == null) {
      return;
    }

    //get route current location to selected location
    //uses flutter_polyline_points library
    final PolylineResult route =
    await polylinePoints?.getRouteBetweenCoordinates(
      'AIzaSyDv9Hn32OA6ARqhVLPzJY9ZDPhlDxjLrVA',
      PointLatLng(currentPosition.latitude, currentPosition.longitude),
      latLng,
    );

    final List<LatLng> polylineCoordinates = [];

    //collect all positional points
    if (route.points.isNotEmpty) {
      route.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        //convert positional points into a PolyLine UI object
        //uses flutter_polyline_points library
        final Polyline polyline = Polyline(
            polylineId: PolylineId('poly'),
            width: 5,
            color: Theme
                .of(context)
                .primaryColor,
            points: polylineCoordinates);

        //show the PolyLine object on the map
        _polylines.add(polyline);
      });

      moveCameraForRoute(currentPosition, latLng);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ColorFiltered(
        colorFilter: ColorFilter.mode(
            loading ? Colors.black.withOpacity(0.5) : Colors.transparent,
            BlendMode.srcATop),
        //uses google_maps_flutter library
        child: GoogleMap(
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: _UK,
            onMapCreated: (GoogleMapController controller) async {
              //start plotting markers when has finished loading
              googleMapController = controller;
              if (!_controller.isCompleted) {
                await _setMarkers(context);
                setState(() {
                  loading = false;
                });
                _controller.complete(controller);
              }
            },
            markers: _markers,
            polylines: _polylines,),
      ),
      loading
      // if loading, show loading animation and message
          ? Align(
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 10),
                        const Text('Adding hotspots...')
                      ]),
                ),
              ),
            )
          //when finished loading, discard loading screen
          : Container(),
      SearchBar(googleApiKey: GOOGLE_API_KEY, showRoute: showRoute,)
    ]);
  }
}
