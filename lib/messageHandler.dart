import 'firebase/functionService.dart';
import 'pages/click_action/clickAction.dart';
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
              return ClickAction(reason: message.data['sickness'], timeOfContact: message.data['timeOfContact'],);
          }));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
