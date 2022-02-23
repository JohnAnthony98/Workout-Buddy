import 'package:flutter/material.dart';
import 'package:workout_buddy_app/services/my_colors.dart';

class WorkoutMain extends StatefulWidget {
  WorkoutMain({Key? key, title}) : super(key: key);

  @override
  _WorkoutMain createState() => _WorkoutMain();
}

class _WorkoutMain extends State<WorkoutMain> {
  DateTime viewingWorkoutDay = DateTime.now();

  String getDate() {
    return viewingWorkoutDay.month.toString() +
        "/" +
        viewingWorkoutDay.day.toString() +
        "/" +
        viewingWorkoutDay.year.toString();
  }

  void viewPreviousDay() {
    setState(() {
      viewingWorkoutDay = viewingWorkoutDay.subtract(const Duration(hours: 24));
    });
  }

  void viewNextDay() {
    setState(() {
      viewingWorkoutDay = viewingWorkoutDay.add(const Duration(hours: 24));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor(),
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
                  border: Border.all(color: getButtonColor(), width: 5.0)),
              child: Text(
                getDate(),
                style: TextStyle(color: getButtonTextColor()),
              ),
            ),
            ElevatedButton(
              onPressed: viewPreviousDay,
              child: const Text("Previous Workout",
                  style: TextStyle(fontSize: 26, color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: viewNextDay,
              child: const Text("Next Workout",
                  style: TextStyle(fontSize: 26, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
