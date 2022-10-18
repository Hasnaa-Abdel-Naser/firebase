import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApp2 extends StatefulWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  State<MyApp2> createState() => _MyAppState2();
}

class _MyAppState2 extends State<MyApp2> {
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
    return FutureBuilder<QuerySnapshot>(
        future: students.get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              'Error happened',
              style: TextStyle(
                fontSize: 26,
              ),
            );
          }

          // if (snapshot.hasData && !snapshot.data!.exists) {
          //   return Text(
          //     "document doesn't exist",
          //     style: TextStyle(
          //       fontSize: 26,
          //     ),
          //   );
          // }

          if (snapshot.connectionState == ConnectionState.done) {
            List col = snapshot.data!.docs;
            List<Widget> widgets = [];
            col.forEach((doc) {
              Map<String, dynamic> data =
              doc.data() as Map<String, dynamic>;
              widgets.add(
                  Column(
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
              widgets.add(Divider(height: 5,color: Colors.black,));
            });

            return SingleChildScrollView(
              child: Column(
                children: widgets,
              ),
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
