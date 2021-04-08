import 'package:covid_19_contact_tracing_app/utilities/contactTracingUtilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

Widget _testWidget(MockBuildContext context) {
  return MaterialApp(
    home: AlertDialog(
      title: const Text('Contact Tracing'),
      content: const Text('Would you like contact tracing to be enabled?'),
      actions: [
        FlatButton(
            onPressed: () {
              ContactTracingUtilities.toggleContactTracing(context, false);
              Navigator.pop(context);
            },
            child: const Text('Leave it off')),
        FlatButton(
            onPressed: () {
              ContactTracingUtilities.toggleContactTracing(context, true);
              Navigator.pop(context);
            },
            child: const Text('Turn it on'))
      ],
    ),
  );
}

//uses mockito library
class MockBuildContext extends Mock implements BuildContext {}

void main() {
  MockBuildContext mockBuildContext;

  setUp(() {
    mockBuildContext = MockBuildContext();
  });

  //uses flutter_test library
  testWidgets('Contact tracing alert dialog properly informs user', (WidgetTester tester) async {
    await tester.pumpWidget(_testWidget(mockBuildContext));

    expect(find.text('Contact Tracing'), findsOneWidget);
    expect(find.text('Would you like contact tracing to be enabled?'), findsOneWidget);
    expect(find.text('Leave it off'), findsOneWidget);
    expect(find.text('Turn it on'), findsOneWidget);
  });
}