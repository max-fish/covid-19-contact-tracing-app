import 'package:flutter/material.dart';

// A page that tells the user what do if they get a notification
class NotificationInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 28, left: 16, right: 16),
        child: Column(
          children: [
            Text('What to do if you get a notification', style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 30,),
            const Text('In the case that you were in contact with someone who is suspected of having COVID-19, '
                'you will receive a notification. Once you have been informed, '
                'head over to the interactions section of the app. '
                'It will tell you around what time this exposure happened, and '
                'if it was based on symptoms or a positive test. By tapping on the '
                'exposure you will see a screen that details further actions.',),
          ],
        ),
      ),
    );
  }
}
