// value object for a covid hotspot map marker
class CovidMarkerModel {
  final String areaName;
  final String areaCode;
  final int newCases;
  final int yesterdayCases;
  final double latitude;
  final double longitude;

  CovidMarkerModel({this.areaName, this.areaCode, this.newCases, this.yesterdayCases, this.latitude, this.longitude});
}