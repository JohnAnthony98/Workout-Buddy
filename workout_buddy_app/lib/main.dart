import 'package:flutter/material.dart';
import 'package:workout_buddy_app/screens/workout_main.dart';
import 'package:workout_buddy_app/screens/workout_creation.dart';
import 'package:workout_buddy_app/screens/home.dart';
import 'package:workout_buddy_app/screens/login.dart';
import 'package:workout_buddy_app/services/my_colors.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/home': (context) => MyHomePage(key: key),
        '/login': (context) => LogInScreen(key: key),
        '/workout_main': (context) => WorkoutMain(key: key),
        '/workout_creation': (context) => WorkoutCreation(key: key),
      },
      title: 'Workout Buddy',
      theme: ThemeData(
        primarySwatch: getPrimarySwatch(),
      ),
      home: LogInScreen(key: key),
    );
  }
}
