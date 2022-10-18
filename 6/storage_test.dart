import 'dart:convert';
import 'dart:typed_data';

import 'package:firestoretest/readQuerySnapshot.dart';
import 'package:firestoretest/readQuerySnapshot_withConverter.dart';
import 'package:firestoretest/realtime_readQuerysnapshot.dart';
import 'package:firestoretest/storage_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class StorageTest extends StatefulWidget {
  const StorageTest({Key? key}) : super(key: key);

  @override
  State<StorageTest> createState() => _StorageTestState();
}

class _StorageTestState extends State<StorageTest> {
  Reference defRef = FirebaseStorage.instance.ref();
  Reference api1Ref = FirebaseStorage.instance.ref('api (1).png');

  // Reference calculatorRef = FirebaseStorage.instance.ref('users/calculator_app.png');
  Reference calculatorRef =
      FirebaseStorage.instance.ref().child('users').child('calculator_app.png');

  listStorageFiles() async {
    ListResult result = await defRef.listAll();

    result.items.forEach((ref) {
      print('Found: ${ref}');
    });
    result.prefixes.forEach((ref) {
      print('Found Prefix: ${ref}');
    });
  }

  List<StorageImage> imageList = [];

  Future<List<StorageImage>> storageList() async {
    List<String> list = await children(defRef);
    List<StorageImage> storageImageList = [];
    for (int i = 0; i < list.length; i++) {
      storageImageList.add(StorageImage(list[i], ''));
    }
    return storageImageList;
  }

  Future<List<String>> children(Reference ref) async {
    List<String> list = [];
    // list = []          // list = []
    ListResult result = await ref.listAll();
    // result = [users, i1, i2 , i3]      // result = [calc]

    // result.items = [i1, i2, i3]
    result.items.forEach((ref) {
      list.add(ref.fullPath);
    });

    for (int i = 0; i < result.prefixes.length; i++) {
      Reference newRef = result.prefixes[i];
      // newRef = Ref of Users
      list.addAll(await children(newRef));
      // list = [calc]
    }

    // list = [calc, i1, i2, i3]
    return list;
  }

  uploadString(String str, {String fileName = 'myText.txt'}) async {
    final encoded = base64Url.encode(utf8.encode(str));
    String dataUrl = 'data:text/plain;base64,${encoded}';
    try {
      await FirebaseStorage.instance.ref('uploads/${fileName}').putString(
            dataUrl,
            format: PutStringFormat.dataUrl,
          );
      showMsg('Upload Success');
    } catch (e) {
      showMsg('Error happened');
    }
  }

  uploadData(String str, {String fileName = 'myText.txt'}) async {
    final encoded = utf8.encode(str);
    Uint8List data = Uint8List.fromList(encoded);
    Reference ref = FirebaseStorage.instance.ref('uploads/${fileName}');
    try {
      await ref.putData(data);
      Uint8List downloadedData = await ref.getData() ?? Uint8List(0);
      showMsg('Upload Success ${utf8.decode(downloadedData)}');
    } catch (e) {
      showMsg('Error happened');
    }
  }

  final cont = TextEditingController();

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
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: cont,
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      uploadString(cont.text, fileName: 'Test.txt');
                    },
                    child: Text(
                      'Upload Text',
                      style: TextStyle(
                        fontSize: 28,
                      ),
                    )),
                ElevatedButton(
                    onPressed: () async {
                      uploadData(cont.text, fileName: 'Data.txt');
                    },
                    child: Text(
                      'Upload Data',
                      style: TextStyle(
                        fontSize: 28,
                      ),
                    )),
                ElevatedButton(
                    onPressed: () async {
                      imageList = await storageList();
                      setState(() {});
                    },
                    child: Text(
                      'List All',
                      style: TextStyle(
                        fontSize: 28,
                      ),
                    )),
                Column(
                  children: imageList
                      .map((image) => Column(
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      image.path,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        image.downloadUrl =
                                            await FirebaseStorage.instance
                                                .ref(image.path)
                                                .getDownloadURL();
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.cloud_download)),
                                  (image.downloadUrl.isEmpty)
                                      ? Container()
                                      : Image.network(
                                          image.downloadUrl,
                                          width: 200,
                                          height: 200,
                                        ),
                                ],
                              ),
                              Divider(
                                height: 5,
                                color: Colors.black,
                              )
                            ],
                          ))
                      .toList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
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
