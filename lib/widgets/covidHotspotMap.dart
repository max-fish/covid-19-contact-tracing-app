import 'dart:async';
import 'dart:io';
import '../utilities/mapPlaces.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

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
  bool loading = true;

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
          await CovidHotspotIconGenerator.getCovidHotpostIcon(
              covidMarkerModel.newCases * 2);
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

  void showSearchedPlace(LatLng latLng) {
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 11)));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ColorFiltered(
        colorFilter: ColorFilter.mode(
            loading ? Colors.black.withOpacity(0.5) : Colors.transparent,
            BlendMode.srcATop),
        child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) async {
              googleMapController = controller;
              if (!_controller.isCompleted) {
                await _setMarkers(context);
                setState(() {
                  loading = false;
                });
                _controller.complete(controller);
              }
            },
            markers: _markers),
      ),
      loading
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
          : Container(),
      Align(
          alignment: const Alignment(0, -0.85),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3))
                ]),
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: PlacesAutocompleteField(
                apiKey: Platform.isAndroid
                    ? 'AIzaSyAFoRipVavXiM6xJauP0GmT9CodLLrvjcY'
                    : 'AIzaSyBEg5Tu1h46jO7sStSmdGwwuBMZO5PSz48',
                mode: Mode.overlay,
                leading: const Icon(Icons.search, color: Colors.blueGrey),
                hint: 'Go Somewhere',
                components: [Component(Component.country, 'uk')],
                onSelected: (Prediction p) async {
                  final LatLng latLng = await MapPlaces.getCoordinates(p);
                  showSearchedPlace(latLng);
                },
                inputDecoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(
                        top: 18.5, bottom: 18.5, left: 0, right: 0),
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
              ),
            ),
          )),
    ]);
  }
}
