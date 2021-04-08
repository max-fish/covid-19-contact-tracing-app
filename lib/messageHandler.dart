import 'firebase/functionService.dart';
import 'pages/click_action/clickAction.dart';
import 'package:flutter/material.dart';

//handles UI when cloud message notification is tapped in the background
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

    //check if app is started through notification
    FunctionService.getInitialMessage().then((message) {
      if(message != null) {
        //load the exposure information page on top of the main screen
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
              return ClickAction(reason: message.data['sickness'], timeOfContact: message.data['timeOfContact'],);
          }));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    //build the main app first
    return widget.child;
  }
}
