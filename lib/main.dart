import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uberlike_flutterlearning/database.dart';
import 'package:uberlike_flutterlearning/screens/home.dart';
import 'package:uberlike_flutterlearning/models/association.dart';
import 'package:uberlike_flutterlearning/models/post.dart';
import 'package:uberlike_flutterlearning/screens/view_post.dart';
import 'firebase_options.dart';
import 'package:mastodon_oauth2/mastodon_oauth2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green[400]!),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
