import 'package:cloud_firestore/cloud_firestore.dart';

import '../../firebase/firestoreService.dart';
import 'package:flutter/material.dart';

class Interactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder(
            stream: FirestoreService.getContactsStream(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data.docs.isNotEmpty) {
                  return ListView(
                    children: snapshot.data.docs.map((document) {
                      final String reason = document['reason'];
                      String trailingText;
                      if (reason == 'SickReason.SYMPTOMS') {
                        trailingText = 'symptoms';
                      } else {
                        trailingText = 'positive test';
                      }
                      return ListTile(
                        leading: Text(document['timeOfContact']),
                        trailing: Text(trailingText),
                      );
                    }).toList(),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      'Phew... You haven\'t been in contact with anybody yet!',
                      style: Theme.of(context).textTheme.headline4,
                          textAlign: TextAlign.center,
                    )),
                  );
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
