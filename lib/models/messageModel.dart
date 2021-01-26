import 'sickReason.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class Message {
  final String userId;
  final bool sick;
  final SickReason reason;
  final DateTime symptomsStartDate;

  Message(
      {@required this.userId,
      @required this.sick,
      this.reason,
      this.symptomsStartDate});

  factory Message.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Message(
        userId: json['userId'],
        sick: json['sick'],
        reason: getReasonFromString(json['reason']),
        symptomsStartDate: json['symptomsStartDate'],
    );
  }

  String toJsonString() {
    return jsonEncode({
      'userId': userId,
      'sick': sick,
      'reason': reason.toString(),
      'symptomsStartDate': symptomsStartDate,
    });
  }
}
