import 'package:flutter/material.dart';

class Interactions extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Near waterloo bridge'),
              subtitle: Text('5 minutes'),
            ),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Picadilly Circus'),
              subtitle: Text('15 minutes'),
            ),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Bromley'),
              subtitle: Text('3.5 min'),
            ),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Borough Market'),
              subtitle: Text('2 hrs'),
            )
          ],
        )
      )
    );
  }
}
