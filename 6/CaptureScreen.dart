import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CaptureScreen extends StatefulWidget {
  CameraDescription camera;

  CaptureScreen({Key? key, required this.camera}) : super(key: key);

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  late CameraController controller;
  late Future<void> initializedControllerFuture;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    initializedControllerFuture = controller.initialize();
  }

  @override
  void dispose() {
    // close camera
    controller.dispose();
    super.dispose();
  }

  uploadFile(String filePath) async {
    File f = File(filePath);
    try {
      await FirebaseStorage.instance
          .ref()
          .child('uploads')
          .child('image1.jpg')
          .putFile(f)
          .then((p0) => showMsg('File Success'));
    } catch (e) {
      showMsg('Error happened');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: initializedControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(controller);
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await initializedControllerFuture;
          final image = await controller.takePicture();
          uploadFile(image.path);
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => DisplayImage(image.path),
            ),
          );
        },
        child: Icon(
          Icons.camera,
          size: 36,
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

class DisplayImage extends StatelessWidget {
  String imagePath;

  DisplayImage(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image'),
        centerTitle: true,
      ),
      body: Image.file(File(imagePath)),
    );
  }
}
