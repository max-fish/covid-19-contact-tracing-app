import 'package:flutter/material.dart';

class DragSection extends StatefulWidget {

  @override
  _DragSectionState createState() => _DragSectionState();
}

class _DragSectionState extends State<DragSection> {
  bool contactTracing = true;
  bool locationSharing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 20.0,
            color: Colors.black.withOpacity(0.2)
          )
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0)
        )
      ),
      child: Column(
        children: [
          Container(
            width: 100.0,
            height: 10.0,
            margin: EdgeInsets.only(top: 15.0),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(5.0))
            ),
          ),
          Row(
            children: [
              Material(
                type: MaterialType.transparency,
                child: Ink(
                  decoration: BoxDecoration(
                    color: contactTracing ? Theme.of(context).primaryColor : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(1000),
                    splashColor: Colors.grey,
                    onTap: () {
                      setState(() {
                        contactTracing = !contactTracing;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                          Icons.bluetooth_audio_rounded,
                          color: contactTracing ? Colors.white : Colors.grey,
                          size: 30
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
