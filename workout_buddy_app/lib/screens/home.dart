import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 56, 53, 53),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/workout_main");
              },
              child: const Text("Workouts",
                  style: TextStyle(fontSize: 26, color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/home");
              },
              child: const Text("Chat",
                  style: TextStyle(fontSize: 26, color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/home");
              },
              child: const Text("Share",
                  style: TextStyle(fontSize: 26, color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/home");
              },
              child: const Text("Friends",
                  style: TextStyle(fontSize: 26, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
