import 'package:covid_19_contact_tracing_app/models/covidMarkerModel.dart';
import 'package:covid_19_contact_tracing_app/widgets/covidHotspotMap.dart';
import 'package:covid_19_contact_tracing_app/widgets/searchBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _testWidget() {
  return MaterialApp(
    home: Scaffold(
      body: CovidHotspotMap(covidData: [
        CovidMarkerModel(
            areaName: 'test area',
            areaCode: '013257',
            newCases: 5,
            yesterdayCases: 3,
            latitude: 54.36,
            longitude: 37.89)
      ]),
    ),
  );
}

//uses flutter_test library
void main() {
  testWidgets('Covid Hotpot Map Displays loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(_testWidget());

    expect(tester.takeException(), isInstanceOf<Null>());
  });

  testWidgets('Covid Hotspot Map has search bar', (WidgetTester tester) async {
    await tester.pumpWidget(_testWidget());

    final searchBar = find.byType(SearchBar);

    expect(searchBar, findsOneWidget);
  });
}


