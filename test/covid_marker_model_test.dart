import 'package:covid_19_contact_tracing_app/models/covidMarkerModel.dart';
import 'package:flutter_test/flutter_test.dart';

void main () {
  test('Covid marker model holds correct data', () {
    final covidMarkerModel = CovidMarkerModel(newCases: 5, yesterdayCases: 3, areaCode: '123456', areaName: 'test name', longitude: 54.56, latitude: 78.39);

    expect(covidMarkerModel.newCases, 5);
    expect(covidMarkerModel.yesterdayCases, 3);
    expect(covidMarkerModel.areaCode, '123456');
    expect(covidMarkerModel.areaName, 'test name');
    expect(covidMarkerModel.latitude, 78.39);
    expect(covidMarkerModel.longitude, 54.56);
  });
}