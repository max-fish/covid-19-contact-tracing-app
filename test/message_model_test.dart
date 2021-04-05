

import 'package:covid_19_contact_tracing_app/models/messageModel.dart';
import 'package:covid_19_contact_tracing_app/models/sickReason.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Message model holds token, sickness, reason, and symptom date', () {
    final message = Message(fcmToken: 'testFcmToken', sick: true, reason: SickReason.POSITIVE_TEST, symptomsStartDate: DateTime.now());

    expect(message.fcmToken.runtimeType, String);
    expect(message.sick.runtimeType, bool);
    expect(message.reason.runtimeType, SickReason);
    expect(message.symptomsStartDate.runtimeType, DateTime);
  });

  test('Message model default sick reason is NOT_SICK', () {
    final message = Message(fcmToken: 'testFcmToken', sick: false);

    expect(message.reason, SickReason.NOT_SICK);
  });

  test('Message model correctly translates to JSON', () {
    final message = Message(fcmToken: 'testFcmToken', sick: true, reason: SickReason.SYMPTOMS);

    final messageJSON = message.toJsonString();

    const expectedString = '{"fcmToken":"testFcmToken","sick":true,"reason":"SickReason.SYMPTOMS","symptomsStartDate":null}';

    expect(messageJSON, expectedString);
  });

  test('Message model correctly translates from JSON', () {
    const messageString = '{"fcmToken":"testFcmToken","sick":true,"reason":"SickReason.SYMPTOMS","symptomsStartDate":null}';
    final message = Message.fromJsonString(messageString);

    expect(message.fcmToken, 'testFcmToken');
    expect(message.sick, true);
    expect(message.reason, SickReason.SYMPTOMS);
    expect(message.symptomsStartDate, null);
  });

}