import 'package:flutter/scheduler.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import '../utilities/userPreferences.dart';
import 'package:flutter/material.dart';
import '../utilities/contactTracingUtilities.dart';
import '../widgets/contactTracingAlertDialog.dart';

// UI for the draggable (sticking out) part of the contact tracing bottom sheet
class DragSection extends StatefulWidget {
  @override
  _DragSectionState createState() => _DragSectionState();
}

class _DragSectionState extends State<DragSection> {

  @override
  void initState() {
    super.initState();
      //if the user can not expressed a contact tracing preference, ask the user
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
                //listens to contact tracing user preference
                //uses streaming_shared_preferences
                child: PreferenceBuilder<bool>(
                    preference: UserPreferences.getContactTracingPreference(),
                    builder: (BuildContext context, bool contactTracingPreference) {
                      // the contact tracing status and toggle button
                      return Ink(
                        decoration: BoxDecoration(
                          //if there is no contact tracing preference yet, default to false
                          color: contactTracingPreference ?? false
                          //if contact tracing enabled, button is blue
                              ? Theme.of(context).primaryColor
                          //if not enabled, button is greyed out
                              : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(1000),
                          splashColor: Colors.grey,
                          onTap: () async {
                            //toggle contact tracing preference
                            await ContactTracingUtilities.toggleContactTracing(
                                context, !contactTracingPreference);
                            //refresh button to change its color
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
