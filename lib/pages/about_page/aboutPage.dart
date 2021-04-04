import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About this app'),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Welcome to the Walkdown contact-tracing app. This app is designed to provide meaningful, real-time information about your surroundings regarding COVID-19 exposure. It uses a combination of bluetooth and sound signals to interact with nearby devices.'),
              const SizedBox(height: 20,),
              const Text('Personal data is never shared to anybody else, because no personal data is ever collected from you. Your user id is anonymized, so nobody knows who you are. The only data that we share to other devices is your health status, and a notification token. This information is used to inform other users if you are sick, to keep everybody safe.'),
              const SizedBox(height: 20,),
              const Text('When searching for a place on a map, your location will be accessed in order to create a route. You location is only used for that instant, and it is never used or queried again.'),
              const SizedBox(height: 20,),
              const Text('This app uses Local District Authority location data from the Office of National Statistics to plot the COVID-19 hot spots. Copyright statements can be found at the bottom.'),
              const SizedBox(height: 20,),
              const Text('Thank you for using Walkdown and stay safe!'),
              const SizedBox(height: 20,),
              const Text('Sincerely,'),
              const SizedBox(height: 10,),
              const Text('The Walkdown Team'),
              const SizedBox(height: 20,),
              Align(alignment: Alignment.bottomCenter, child: Text('Source: Office for National Statistics licensed under the Open Government Licence v.3.0', style: Theme.of(context).textTheme.button)),
              const SizedBox(height: 10,),
              Align(alignment: Alignment.bottomCenter, child: Text('Contains OS data © Crown copyright and database right 2021', style: Theme.of(context).textTheme.button,))
            ],
          ),
        ),
      ),
    );
  }
}
