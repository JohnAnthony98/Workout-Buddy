import 'package:flutter/material.dart';

class WorkoutMain extends StatefulWidget {
  WorkoutMain({Key? key, title}) : super(key: key);

  @override
  _WorkoutMain createState() => _WorkoutMain();
}

class _WorkoutMain extends State<WorkoutMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 56, 53, 53),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Workouts!"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 5.0)),
              child: const Text(
                'Daily Workout Here',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context,
                    "/future_workouts"); ////////Pressing breaks app as of 2/22/2022////////
              },
              child: const Text("Future Workouts",
                  style: TextStyle(fontSize: 26, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
