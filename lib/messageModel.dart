import 'package:covid_19_contact_tracing_app/sickReason.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class Message {
  final String userId;
  final bool sick;
  final SickReason reason;
  final DateTime symptomsStartDate;
  final List symptoms;

  Message(
      {@required this.userId,
      @required this.sick,
      this.reason,
      this.symptomsStartDate,
      this.symptoms});

  factory Message.fromJsonString(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return Message(
        userId: json['userId'],
        sick: json['sick'],
        reason: json['reason'],
        symptomsStartDate: json['symptomsStartDate'],
        symptoms: json['symptoms']);
  }

  String toJsonString() {
    return jsonEncode({
      'userId': userId,
      'sick': sick,
      'reason': reason,
      'symptomsStartDate': symptomsStartDate,
      'symptoms': symptoms
    });
  }
}
