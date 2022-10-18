import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApp3 extends StatefulWidget {
  const MyApp3({Key? key}) : super(key: key);

  @override
  State<MyApp3> createState() => _MyAppState3();
}

class _MyAppState3 extends State<MyApp3> {
  final firestore = FirebaseFirestore.instance;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase App'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: loader(context),
      ),
    );
  }

  Widget loader(BuildContext context) {
    CollectionReference students = firestore.collection('students');
    return StreamBuilder<QuerySnapshot>(
        stream:
            students.where('name', isNotEqualTo: 'Omar')
            .orderBy('name', descending: true)
                .limit(3).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              'Error happened',
              style: TextStyle(
                fontSize: 26,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text(
              'Waiting...',
              style: TextStyle(
                fontSize: 30,
              ),
            );
          }

          List col = snapshot.data!.docs; // [{doc}, {doc}, {doc}]
          List<Widget> widgets = [];
          col.forEach((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            widgets.add(Column(
              children: [
                Text(
                  'Name: ${data['name']}',
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
                Text(
                  'Age: ${data['age']}',
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
              ],
            ));
            widgets.add(Divider(
              height: 5,
              color: Colors.black,
            ));
          });

          return SingleChildScrollView(
            child: Column(
              children: widgets,
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
