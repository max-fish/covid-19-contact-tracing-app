import 'package:flutter/scheduler.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import '../utilities/userPreferences.dart';
import 'package:flutter/material.dart';
import '../utilities/contactTracingUtilities.dart';
import '../widgets/contactTracingAlertDialog.dart';

class DragSection extends StatefulWidget {
  @override
  _DragSectionState createState() => _DragSectionState();
}

class _DragSectionState extends State<DragSection> {
  bool locationSharing = false;

  @override
  void initState() {
    super.initState();
      if(!UserPreferences.containsContactTracing()) {
        SchedulerBinding.instance.addPostFrameCallback(
                (_) => showContactTracingAlertDialog(context)
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(blurRadius: 20.0, color: Colors.black.withOpacity(0.2))
          ],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))),
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
                child: PreferenceBuilder<bool>(
                    preference: UserPreferences.getContactTracingPreference(),
                    builder: (BuildContext context, bool contactTracingPreference) {
                      return Ink(
                        decoration: BoxDecoration(
                          color: contactTracingPreference ?? false
                              ? Theme.of(context).primaryColor
                              : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(1000),
                          splashColor: Colors.grey,
                          onTap: () async {
                            await ContactTracingUtilities.toggleContactTracing(
                                context, !contactTracingPreference);
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(Icons.bluetooth_audio_rounded,
                                color: (contactTracingPreference ?? false)
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
