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

// UI for the bottom draggable sheet on top of the map
class ContactTracingBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //uses snapping_sheet library
    return SnappingSheet(
      sheetBelow: SnappingSheetContent(
        //contains UI that is initially hidden
        child: Container(
          color: Colors.white,
          child: GridView.count(
            crossAxisCount: 2,
            children: [
              //listens to user contact tracing preference
              //uses streaming_shared_preferences library
              PreferenceBuilder<bool>(
                  preference:
                  UserPreferences.getContactTracingPreference(),
                  builder: (BuildContext context,
                      bool contactTracingPreference) {
                    return PageButton(
                        icon: Icons.thermostat_rounded,
                        pageName: 'Check Symptoms',
                        //if contact tracing enabled, show symptoms page
                        //if not enabled, button is disabled
                        onPress: contactTracingPreference
                            ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SymptomsSelection()))
                            : null);
                  }),
              //uses snapping_sheet library
              PreferenceBuilder<bool>(
                  preference:
                  UserPreferences.getContactTracingPreference(),
                  builder: (BuildContext context,
                      bool contactTracingPreference) {
                    return PageButton(
                        icon: Icons.input_rounded,
                        pageName: 'I am positive for COVID-19',
                        //if contact tracing enabled, show positive test page
                        //if not enabled, button is disabled
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
      // part of the bottom sheet that sticks out
      grabbing: DragSection(),
      grabbingHeight: 100,
      // initially, the bottom sheet is closed
      initSnapPosition: const SnapPosition(positionFactor: 0),
      snapPositions: [
        // when dragged, the bottom sheet can be in either a closed position (0),
        // or a open half way up (0.5)
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
