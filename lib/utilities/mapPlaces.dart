import 'dart:io';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

class MapPlaces {
  static Future<PointLatLng> getCoordinates(Prediction p) async {
      final GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: Platform.isAndroid ? 'AIzaSyAFoRipVavXiM6xJauP0GmT9CodLLrvjcY' : 'AIzaSyBEg5Tu1h46jO7sStSmdGwwuBMZO5PSz48',
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      final PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      return PointLatLng(lat, lng);
  }
}