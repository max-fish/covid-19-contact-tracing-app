import 'sickReason.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

// value object holding the user status for device-to-device communication
class Message {
  final String fcmToken;
  final bool sick;
  final SickReason reason;
  final DateTime symptomsStartDate;

  Message(
      {@required this.fcmToken,
      @required this.sick,
      this.reason = SickReason.NOT_SICK,
      this.symptomsStartDate});

  //make this object from a json string when receiving a message
  factory Message.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Message(
        fcmToken: json['fcmToken'],
        sick: json['sick'],
        reason: getReasonFromString(json['reason']),
        symptomsStartDate: json['symptomsStartDate'],
    );
  }

  //convert to json string when broadcasting this message
  String toJsonString() {
    return jsonEncode({
      'fcmToken': fcmToken,
      'sick': sick,
      'reason': reason.toString(),
      'symptomsStartDate': symptomsStartDate,
    });
  }
}
