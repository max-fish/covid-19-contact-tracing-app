import 'package:covid_19_contact_tracing_app/symptoms/SymptomCard.dart';
import 'package:flutter/material.dart';

import 'confirmSymptoms.dart';

class SymptomsSelection extends StatefulWidget {
  @override
  _SymptomsSelectionState createState() => _SymptomsSelectionState();
}

class _SymptomsSelectionState extends State<SymptomsSelection> {
  bool highTemp = false;
  bool cough = false;
  bool changeSmellTaste = false;

  void highTempToggle() {
    setState(() {
      highTemp = !highTemp;
    });
  }

  void coughToggle() {
    setState(() {
      cough = !cough;
    });
  }

  void changeSmellTasteToggle() {
    setState(() {
      changeSmellTaste = !changeSmellTaste;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What symptoms are you feeling?',
              style: Theme.of(context).textTheme.headline4,
            ),
            SymptomCard(
              active: highTemp,
              onActiveChange: highTempToggle,
              title: 'A high temperature (fever)',
              description: 'Does your chest or back feel hot?',
            ),
            SymptomCard(
              active: cough,
              onActiveChange: coughToggle,
              title: 'A new continuous cough',
              description:
                  'Are you coughing a lot more than an hour, or three or more coughing episodes in 24 hours that are worse than usual?',
            ),
            SymptomCard(
              active: changeSmellTaste,
              onActiveChange: changeSmellTasteToggle,
              title: 'A change to your sense of smell or taste',
              description:
                  'Have you noticed that you cannot smell or taste anything, or that things smell or taste different to normal?',
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'none of these',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  decoration: TextDecoration.underline),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              margin: EdgeInsets.only(left: 24, right: 24),
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ConfirmSymptoms(confirmHighTemp: highTemp, confirmCough: cough, confirmChangeSmellTaste: changeSmellTaste,);
                  }));
                },
                child: Text('Continue'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
