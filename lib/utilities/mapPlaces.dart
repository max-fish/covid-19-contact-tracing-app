import 'dart:io';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class MapPlaces {
  static Future<LatLng> getCoordinates(Prediction p) async {
    print('prediction');
      // get detail (lat/lng)
      final GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: Platform.isAndroid ? 'AIzaSyAFoRipVavXiM6xJauP0GmT9CodLLrvjcY' : 'AIzaSyBEg5Tu1h46jO7sStSmdGwwuBMZO5PSz48',
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      final PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      return LatLng(lat, lng);
  }
}