import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaze/auth/login.dart';
import 'package:firebaze/auth/sign_up.dart';
import 'package:firebaze/categories/add.dart';
import 'package:firebaze/homepage.dart';
import 'package:firebaze/users.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAGmpiqxefXDQitFIMsNrgGUVrXirSX7aU',
      appId: '1:865558594894:android:7e902f31cb7040db91ca1f',
      messagingSenderId: '865558594894',
      projectId: 'mahmoud-463ef',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // ignore: avoid_print
        print('User is currently signed out!');
      } else {
        // ignore: avoid_print
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => const Login(),
        '/sign_up': (context) => const SignUp(),
        '/homepage': (context) => const HomePage(),
        '/addcategory': (context) => const AddCategory(),
        '/users': (context) => const Users(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:const Users(),
      //FirebaseAuth.instance.currentUser==null? const Login():const HomePage(),
    );
  }
}
