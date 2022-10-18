import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'CaptureScreen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (_) => AuthApp(),
    },
  ));
}

class AuthApp extends StatefulWidget {
  const AuthApp({Key? key}) : super(key: key);

  @override
  State<AuthApp> createState() => _AuthAppState();
}

class _AuthAppState extends State<AuthApp> {
  checkByAuthStateChanges() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((user) {
      if (user == null) {
        showMsg('State Change: User sign out');
      } else {
        showMsg('State Change: user signed In');
      }
    });
  }

  checkByIdToken() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.idTokenChanges().listen((user) {
      if (user == null) {
        showMsg('Id Token: User sign out');
      } else {
        showMsg('Id Token: user signed In');
      }
    });
  }

  checkByUserChanges() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.userChanges().listen((user) {
      if (user == null) {
        showMsg('User changes: User sign out');
      } else {
        showMsg('User changes: user signed In');
      }
    });
  }

  signInAnonymously() async {
    final cred = await FirebaseAuth.instance.signOut();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      showMsg('UserId: ${user.uid}');
    }
  }

  signUpWithUsernameAndPassword(email, password) async {
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
      if (user != null) {
        showMsg('UserId: ${cred.user!.email} \n'
            'Email verified: ${cred.user!.emailVerified}\n'
            'Last time: ${cred.user!.metadata.lastSignInTime}');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showMsg('Password is weak');
      } else if (e.code == 'email-already-in-use') {
        showMsg('Email already exist');
      }
    } catch (e) {
      showMsg('Error happened');
    }
  }

  signInWithUsernameAndPassword(email, password) async {
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        showMsg('Login Failed, please verify email');
      } else if (user != null) {
        showMsg('UserId: ${cred.user!.email} \n'
            'Email verified: ${cred.user!.emailVerified}\n'
            'Last time: ${cred.user!.metadata.lastSignInTime}');
      }
    } catch (e) {
      showMsg('Error happened');
    }
  }

  final emailCont = TextEditingController();
  final passwordCont = TextEditingController();

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
              TextField(
                controller: emailCont,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              TextField(
                controller: passwordCont,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    signInWithUsernameAndPassword(
                      emailCont.text,
                      passwordCont.text,
                    );
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    signUpWithUsernameAndPassword(
                      emailCont.text,
                      passwordCont.text,
                    );
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    checkByAuthStateChanges();
                  },
                  child: Text(
                    'Check',
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    signInAnonymously();
                  },
                  child: Text(
                    'Sign In Anonymously',
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
