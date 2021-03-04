import 'firebase/functionService.dart';
import 'models/sickReason.dart';
import 'pages/click_action/clickActionPositiveTest.dart';
import 'pages/click_action/clickActionSymptoms.dart';
import 'package:flutter/material.dart';

class MessageHandler extends StatefulWidget {
  final Widget child;
  MessageHandler({this.child});
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  Widget child;

  @override
  void initState() {
    super.initState();

    FunctionService.getInitialMessage().then((message) {
      if(message != null) {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
            if(getReasonFromString(message.data['sickness']) == SickReason.SYMPTOMS) {
              return ClickActionSymptoms();
            }
            else{
              return ClickActionPositiveTest();
            }
          }));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
