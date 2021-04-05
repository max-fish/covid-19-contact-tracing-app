import 'package:covid_19_contact_tracing_app/models/coronavirusDataModel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Coronavirus data model contains necessary fields', () {
    const covidDataModel = CoronavirusDataModel(
      areaName: 'test name',
      areaCode: '0134556',
      newCases: 5,
      yesterdayCases: 3
    );

    expect(covidDataModel.areaName, 'test name');
    expect(covidDataModel.areaCode, '0134556');
    expect(covidDataModel.newCases, 5);
    expect(covidDataModel.yesterdayCases, 3);
  });

  test('Coronavirus data model correctly translates from JSON', () {
    final json = <String, dynamic>{'areaName' : 'test name', 'areaCode': '0134556', 'newCases': 5, 'yesterdayCases': 3};

    final covidDataModelFromJson = CoronavirusDataModel.fromJson(json);

    expect(covidDataModelFromJson.areaName, 'test name');
    expect(covidDataModelFromJson.areaCode, '0134556');
    expect(covidDataModelFromJson.newCases, 5);
    expect(covidDataModelFromJson.yesterdayCases, 3);
  });

}