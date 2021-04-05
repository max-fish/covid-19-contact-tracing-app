import 'package:covid_19_contact_tracing_app/pages/about_page/aboutPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('About page has correct copyright text for ONS', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AboutPage()));

    expect(find.text('Source: Office for National Statistics licensed under the Open Government Licence v.3.0'), findsOneWidget);
    expect(find.text('Contains OS data © Crown copyright and database right 2021'), findsOneWidget);
  });
}