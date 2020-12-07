import 'package:flutter/material.dart';

class ConfirmSymptoms extends StatelessWidget {
  final bool confirmHighTemp;
  final bool confirmCough;
  final bool confirmChangeSmellTaste;

  ConfirmSymptoms(
      {this.confirmHighTemp, this.confirmCough, this.confirmChangeSmellTaste});

  @override
  Widget build(BuildContext context) {
    final List<List> confirmSymptomList = [
      [confirmHighTemp, "A high temperature (fever)"],
      [confirmCough, "A new continuous cough"],
      [confirmChangeSmellTaste, "A change to your sense of smell or taste"]
    ];

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Confirm your symptoms", style: Theme.of(context).textTheme.headline4,),
            SizedBox(height: 16,),
            Align(alignment: Alignment.centerLeft,child: Text("You are experiencing:", style: Theme.of(context).textTheme.headline6)),
            SizedBox(height: 16,),
            ...confirmSymptomList.where((element) => element[0])
            .map((e) => Card(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.check, color: Colors.green,),
                  Text(e[1]),
                ],
              ),
            ))),
            SizedBox(height: 16,),
            Align(alignment: Alignment.centerLeft,child: Text("You are not experiencing:", style: Theme.of(context).textTheme.headline6,)),
            SizedBox(height: 16,),
            ...confirmSymptomList.where((element) => !element[0])
            .map((e) => Card(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.close, color: Colors.red),
                  Text(e[1]),
                ],
              ),
            ))),
            SizedBox(height: 24,),
            Container(
              margin: EdgeInsets.only(left: 24, right: 24),
              child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text("Confirm symptoms"),
                  onPressed: () {}),
            )
          ],
        ),
      ),
    );
  }
}
