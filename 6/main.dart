import 'package:firestoretest/add_image.dart';
import 'package:firestoretest/batch.dart';
import 'package:firestoretest/readQuerySnapshot.dart';
import 'package:firestoretest/readQuerySnapshot_withConverter.dart';
import 'package:firestoretest/realtime_readQuerysnapshot.dart';
import 'package:firestoretest/storage_test.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Connect to Firebase project
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: StorageTest(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final firestore = FirebaseFirestore.instance;
  final nameCont = TextEditingController();
  final ageCont = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase App'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: nameCont,
            ),
            TextField(
              controller: ageCont,
            ),
            ElevatedButton(
                onPressed: () {
                  firestore.collection('students').doc('ABC').
                  // delete()
                      // Set can add doc or edit doc
                      update(
                    {
                      // 'name': nameCont.text,
                      // 'age': int.parse(ageCont.text),
                      'location': FieldValue.delete(),
                    },)
                  .then((value) => showMsg('Doc success'));
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ))
          ],
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
