import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'confirmPublishSymptoms.dart';

class SymptomsDatePicker extends StatefulWidget {
  final bool highTemp;
  final bool cough;
  final bool changeSmellTaste;

  const SymptomsDatePicker({this.highTemp, this.cough, this.changeSmellTaste});

  @override
  _SymptomsDatePickerState createState() => _SymptomsDatePickerState();
}

class _SymptomsDatePickerState extends State<SymptomsDatePicker> {
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now().toLocal();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: currentDate.subtract(const Duration(days: 5)),
      lastDate: currentDate,
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Date'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'When did your symptoms start?',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('d MMMM y').format(selectedDate),
                    style: Theme.of(context)
                        .textTheme
                        .headline4,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlineButton(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                    color: Colors.white,
                    onPressed: () => _selectDate(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: 
                        [
                          Icon(Icons.calendar_today_rounded, color: Theme.of(context).primaryColor,),
                          const SizedBox(width: 5,),
                          Text(
                          'Select Date',
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.65),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width * 0.8,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: const Text('Confirm Date', style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const ConfirmPublishSymtoms();
                    }));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
