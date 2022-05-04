import 'package:flutter/material.dart';
import 'package:workout_buddy_app/screens/message_main.dart';
import 'package:workout_buddy_app/screens/friends_list.dart';
import 'package:workout_buddy_app/screens/friend_requests.dart';
import 'package:workout_buddy_app/screens/signup.dart';
import 'package:workout_buddy_app/screens/workout_main.dart';
import 'package:workout_buddy_app/screens/workout_creation_selection.dart';
import 'package:workout_buddy_app/screens/home.dart';
import 'package:workout_buddy_app/screens/login.dart';
import 'package:workout_buddy_app/services/style.dart';
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
        '/signup': (context) => SignUpScreen(key: key),
        '/workout_main': (context) => WorkoutMain(key: key),
        '/workout_creation_selection': (context) =>
            WorkoutCreationSelection(key: key),
        '/message_main': (context) => UsersPage(key: key),
        '/friends_list': (context) => FriendsList(key: key),
        '/friend_requests': (context) => FriendRequests(key: key),
      },
      title: 'Workout Buddy',
      theme: ThemeData(
        primarySwatch: getPrimarySwatch(),
      ),
      home: LogInScreen(key: key),
    );
  }
}
