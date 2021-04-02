import '../utilities/mapPlaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';

class SearchBar extends StatelessWidget {
  final String googleApiKey;
  final Function showRoute;

  SearchBar({this.googleApiKey, this.showRoute});

  @override
  Widget build(BuildContext context) {
    return Align(
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
              apiKey: googleApiKey,
              mode: Mode.overlay,
              leading: const Icon(Icons.search, color: Colors.blueGrey),
              hint: 'Go Somewhere',
              components: [Component(Component.country, 'uk')],
              onSelected: (Prediction p) async {
                final PointLatLng latLng = await MapPlaces.getCoordinates(p);
                showRoute(latLng);
              },
              inputDecoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(
                      top: 18, bottom: 18, left: 0, right: 0),
                  border: OutlineInputBorder(borderSide: BorderSide.none)),
            ),
          ),
        ));
  }
}
