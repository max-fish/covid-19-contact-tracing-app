import 'package:cloud_firestore/cloud_firestore.dart';
import '../click_action/clickAction.dart';

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
                  return Padding(
                    padding: const EdgeInsets.only(top: 28, left: 16, right: 16),
                    child: Column(
                      children: [
                        Text('Interactions', style: Theme.of(context).textTheme.headline4,),
                        const SizedBox(height: 20,),
                        Expanded(
                          child: ListView(
                            children: snapshot.data.docs.map((document) {
                              final String reason = document['reason'];
                              String trailingText;
                              if (reason == 'SickReason.SYMPTOMS') {
                                trailingText = 'Symptoms';
                              } else if(reason == 'SickReason.POSITIVE_TEST') {
                                trailingText = 'Positive Test';
                              }
                              else{
                                trailingText = 'Not Sick';
                              }
                              return Card(
                                child: ListTile(
                                  leading: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.access_time),
                                      const SizedBox(width: 5,),
                                      Text(document['timeOfContact']),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.connect_without_contact_rounded),
                                      const SizedBox(width: 5,),
                                      Text(trailingText),
                                    ],
                                  ),
                                  contentPadding: const EdgeInsets.all(8),
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                    return ClickAction(reason: reason, timeOfContact: document['timeOfContact']);
                                  })),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
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
