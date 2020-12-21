import 'package:covid_19_contact_tracing_app/utilities/contactTracingUtilities.dart';
import 'package:flutter/material.dart';

class ConfirmPublishSymtoms extends StatelessWidget {
  final bool highTemp;
  final bool cough;
  final bool changeSmellTaste;
  final DateTime startDate;

  const ConfirmPublishSymtoms(
      {this.highTemp, this.cough, this.changeSmellTaste, this.startDate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                'We will now notify people who you have been in contact with that you are experiencing symptoms of COVID-19. No personal data will be shared. Is this ok?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: 
                [
                  RaisedButton(
                    color: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    child: Text('Cancel', style: TextStyle(color: Colors.white),),
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),),
                  SizedBox(width: 10,),
                  RaisedButton(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  child: Text('Submit', style: TextStyle(color: Colors.white)),
                  onPressed: () =>
                      ContactTracingUtilities.publishSymptoms(context, startDate),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
