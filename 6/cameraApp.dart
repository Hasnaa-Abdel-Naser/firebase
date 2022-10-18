import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'CaptureScreen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (_) => CameraApp(),
      '/camera': (_) => CaptureScreen(
        camera: firstCamera,
      ),
    },
  ));
}

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {



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
                    Navigator.pushNamed(context, '/camera');
                  },
                  child: Text(
                    'Take Picture',
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
