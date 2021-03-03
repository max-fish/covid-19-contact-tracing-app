import 'sickReason.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class Message {
  final String fcmToken;
  final bool sick;
  final SickReason reason;
  final DateTime symptomsStartDate;

  Message(
      {@required this.fcmToken,
      @required this.sick,
      this.reason,
      this.symptomsStartDate});

  factory Message.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Message(
        fcmToken: json['fcmToken'],
        sick: json['sick'],
        reason: getReasonFromString(json['reason']),
        symptomsStartDate: json['symptomsStartDate'],
    );
  }

  String toJsonString() {
    return jsonEncode({
      'fcmToken': fcmToken,
      'sick': sick,
      'reason': reason.toString(),
      'symptomsStartDate': symptomsStartDate,
    });
  }
}
