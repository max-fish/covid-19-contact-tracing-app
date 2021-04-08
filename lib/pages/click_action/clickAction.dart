import 'package:url_launcher/url_launcher.dart';

import '../../models/sickReason.dart';
import 'package:flutter/material.dart';

// Page that describes an interaction in more detail
class ClickAction extends StatelessWidget {
  final String reason;
  final String timeOfContact;

  ClickAction({this.reason, this.timeOfContact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //prints description text based on the reason of exposure
              Text(getReasonFromString(reason) == SickReason.SYMPTOMS ? 'You have been in contact with someone on ' + timeOfContact + ' who has symptoms of COVID-19.' : 'You have been in contact with someone on ' + timeOfContact + ' who tested positive for COVID-19.', style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal), textAlign: TextAlign.center,),
              const SizedBox(height: 10,),
              Text('Please remain vigilant about your well-being and refer to the link below about self-isolation in the case you develop any symptoms.', style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal), textAlign: TextAlign.center,),
              const SizedBox(height: 10),
              //url_launcher library is used to launch the device's browser app upon tapping on the link
              InkWell(child: const Text('NHS Self-Isolation Information Link', style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),), onTap: () => launch('https://www.nhs.uk/conditions/coronavirus-covid-19/self-isolation-and-treatment/when-to-self-isolate-and-what-to-do/'),)
            ],
          ),
        ),
      ),
    );
  }
}
