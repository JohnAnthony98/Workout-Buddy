import 'package:flutter/material.dart';
import 'package:workout_buddy_app/screens/workout_main.dart';
import 'package:workout_buddy_app/screens/home.dart';

void main() {
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
        '/home': (context) => MyHomePage(key: key, title: 'Workout Buddy'),
        '/workout_main': (context) =>
            WorkoutMain(key: key, title: "Workout Main Page"),
      },
      title: 'Workout Buddy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(key: key, title: "Workout Buddy"),
    );
  }
}
