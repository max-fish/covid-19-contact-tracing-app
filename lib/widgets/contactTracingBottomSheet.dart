import '../pages/about_page/aboutPage.dart';
import '../pages/interactions/interactions.dart';
import '../pages/notification_information/notificationInformation.dart';
import '../pages/positive_test/positiveTest.dart';
import '../pages/symptoms/symptomsSelection.dart';
import 'pageButton.dart';
import '../utilities/userPreferences.dart';
import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'dragSection.dart';

class ContactTracingBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SnappingSheet(
      sheetBelow: SnappingSheetContent(
        child: Container(
          color: Colors.white,
          child: GridView.count(
            crossAxisCount: 2,
            children: [
              PreferenceBuilder<bool>(
                  preference:
                  UserPreferences.getContactTracingPreference(),
                  builder: (BuildContext context,
                      bool contactTracingPreference) {
                    return PageButton(
                        icon: Icons.thermostat_rounded,
                        pageName: 'Check Symptoms',
                        onPress: contactTracingPreference
                            ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SymptomsSelection()))
                            : null);
                  }),
              PreferenceBuilder<bool>(
                  preference:
                  UserPreferences.getContactTracingPreference(),
                  builder: (BuildContext context,
                      bool contactTracingPreference) {
                    return PageButton(
                        icon: Icons.input_rounded,
                        pageName: 'I am positive for COVID-19',
                        onPress: contactTracingPreference
                            ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TestResult()))
                            : null);
                  }),
              PageButton(
                icon: Icons.list_alt_rounded,
                pageName: 'View Interactions',
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Interactions()));
                },
              ),
              PageButton(
                icon: Icons.notifications_active_rounded,
                pageName:
                'I got an exposure notification. What should I do?',
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NotificationInformation()));
                },
              ),
              PageButton(
                icon: Icons.info_outline_rounded,
                pageName: 'About this app',
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AboutPage()));
                },
              ),
            ],
          ),
        ),
        heightBehavior: const SnappingSheetHeight.fixed(),
      ),
      grabbing: DragSection(),
      grabbingHeight: 100,
      initSnapPosition: const SnapPosition(positionFactor: 0),
      snapPositions: [
        const SnapPosition(
            positionFactor: 0,
            snappingDuration: Duration(milliseconds: 100)),
        const SnapPosition(
            positionFactor: 0.5,
            snappingDuration: Duration(milliseconds: 100)),
      ],
    );
  }
}
