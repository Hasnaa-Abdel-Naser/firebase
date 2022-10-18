import 'dart:typed_data';

import 'package:firestoretest/readQuerySnapshot.dart';
import 'package:firestoretest/readQuerySnapshot_withConverter.dart';
import 'package:firestoretest/realtime_readQuerysnapshot.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class AddImage extends StatefulWidget {
  const AddImage({Key? key}) : super(key: key);

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
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
                    rootBundle
                        .load('images/image1.png')
                        .then((bytes) => bytes.buffer.asUint8List())
                        .then((avatar) =>
                            firestore.collection('students').doc('ABC').update(
                              {
                                'photo': Blob(avatar),
                              },
                            ).then((value) => showMsg('Doc success')));
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    firestore.collection('students').doc('ABC').get().then((doc) {
                      var blob = doc['photo'];
                      setState(() {
                        image = blob;
                      });
                    });
                    // rootBundle
                    //     .load('images/image1.png')
                    //     .then((bytes) => bytes.buffer.asUint8List())
                    //     .then((avatar) =>
                    //     firestore.collection('students').doc('ABC').update(
                    //       {
                    //         'photo': Blob(avatar),
                    //       },
                    //     ).then((value) => showMsg('Doc success')));
                  },
                  child: Text(
                    'Load',
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  )),
              (image.bytes.isEmpty)
                  ? Container()
                  : Container(
                      width: 200,
                      height: 200,
                      child: Image.memory(image.bytes),
                    )
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
