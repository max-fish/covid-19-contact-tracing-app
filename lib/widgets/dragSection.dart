import '../utilities/sharedPreferences.dart';
import 'package:flutter/material.dart';
import '../utilities/contactTracingUtilities.dart';

class DragSection extends StatefulWidget {
  @override
  _DragSectionState createState() => _DragSectionState();
}

class _DragSectionState extends State<DragSection> {
  bool locationSharing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(blurRadius: 20.0, color: Colors.black.withOpacity(0.2))
          ],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
      child: Column(
        children: [
          Container(
            width: 100.0,
            height: 10.0,
            margin: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.all(Radius.circular(5.0))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                type: MaterialType.transparency,
                child: FutureBuilder(
                    future: UserPreferences.getContactTracingPreference(),
                    builder: (context, snapshot) {
                      return Ink(
                        decoration: BoxDecoration(
                          color: snapshot.data ?? false
                              ? Theme.of(context).primaryColor
                              : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(1000),
                          splashColor: Colors.grey,
                          onTap: () async {
                            await ContactTracingUtilities.toggleContactTracing(
                                context, !snapshot.data);
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(Icons.bluetooth_audio_rounded,
                                color: (snapshot.data ?? false)
                                    ? Colors.white
                                    : Colors.grey,
                                size: 30),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ],
      ),
    );
  }
}
