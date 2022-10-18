import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Student.dart';

class MyApp4 extends StatefulWidget {
  const MyApp4({Key? key}) : super(key: key);

  @override
  State<MyApp4> createState() => _MyAppState4();
}

class _MyAppState4 extends State<MyApp4> {
  final studentRef = FirebaseFirestore.instance
      .collection('students').withConverter(
    // read from databse
      fromFirestore: ((snapshot, _) => Student.fromMap(snapshot.data()!)),
     // Write to database
      toFirestore: (st , _) => st.toMap());

  Widget build(BuildContext context) {
    studentRef.doc('20V78Jna3lLWHRjpsaxk').get().then((doc){
      Student s = doc.data()! as Student;
      showMsg('doc loaded with ${s.name}');
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase App'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child:  Container()
        // Column(
        //   children: [
        //     Text(
        //       'Name: ${data['name']}',
        //       style: TextStyle(
        //         fontSize: 32,
        //       ),
        //     ),
        //     Text(
        //       'Age: ${data['age']}',
        //       style: TextStyle(
        //         fontSize: 32,
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  Widget loader(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('students')
            .get(),
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
