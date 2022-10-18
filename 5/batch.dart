import 'dart:typed_data';

import 'package:firestoretest/readQuerySnapshot.dart';
import 'package:firestoretest/readQuerySnapshot_withConverter.dart';
import 'package:firestoretest/realtime_readQuerysnapshot.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class BatchUpdate extends StatefulWidget {
  const BatchUpdate({Key? key}) : super(key: key);

  @override
  State<BatchUpdate> createState() => _BatchUpdateState();
}

class _BatchUpdateState extends State<BatchUpdate> {
  final firestore = FirebaseFirestore.instance;
  Blob image = Blob(Uint8List(0));

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase App'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    WriteBatch batch = firestore.batch();
                    firestore.collection('students').get().then((snapshot){
                      snapshot.docs.forEach((doc) {
                        batch.set(doc.reference, {'gender': 'male'}, SetOptions(merge: true));
                      });
                      batch.commit();
                    } );
                  },
                  child: Text(
                    'Batch Update',
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  )),

            ],
          ),
        ),
      ),
    );
  }

  Widget loader(BuildContext context) {
    CollectionReference students = firestore.collection('students');
    return FutureBuilder<DocumentSnapshot>(
        future: students.doc('JyPhUQzuv7JnMZqOubdx').get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              'Error happened',
              style: TextStyle(
                fontSize: 26,
              ),
            );
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text(
              "document doesn't exist",
              style: TextStyle(
                fontSize: 26,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              children: [
                Text(
                  'Name: ${data['name']}',
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
                Text(
                  'Age: ${data['age']}',
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
              ],
            );
          }
          return Text(
            'Loading...',
            style: TextStyle(
              fontSize: 26,
            ),
          );
        });
  }

  showMsg(msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
        msg,
        style: TextStyle(
          fontSize: 26,
        ),
      )),
    );
  }
}
