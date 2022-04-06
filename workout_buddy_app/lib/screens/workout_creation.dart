// ignore_for_file: non_constant_identifier_names
import 'dart:collection';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_buddy_app/services/my_colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutCreation extends StatefulWidget {
  const WorkoutCreation(
      {Key? key, title, required this.clientID, required this.workoutDay})
      : super(key: key);

  final String clientID;
  final String workoutDay;

  @override
  _WorkoutCreation createState() => _WorkoutCreation();
}

class _WorkoutCreation extends State<WorkoutCreation> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  late String exercise;
  late String reps;
  late int set_reps;
  int num_sets = 0;
  List allSets = [[]];

  bool workout_submitted = false;

  String getDate() {
    return widget.workoutDay;
  }

  String parseWorkout(String workout) {
    List<String> splitted = workout.split(":");
    return "Exercise: " + splitted[0] + " Reps: " + splitted[1];
  }

  String createWorkoutString(String e, String r) {
    return e + ":" + r;
  }

  String printCurrentSet() {
    String set = "";
    for (String i in allSets[num_sets]) {
      set += parseWorkout(i) + "\n";
    }
    return set;
  }

  void addToSet() {
    allSets[num_sets].add(createWorkoutString(exercise, reps));
    setState(() {});
  }

  void finishSet() {
    allSets[num_sets].insert(0, set_reps);
    num_sets++;
    allSets.add([]);
    setState(() {});
  }

  Future<void> submitWorkout() {
    Map<String, Object> data = HashMap();
    data.putIfAbsent('Date', () => getDate());
    data.putIfAbsent('NumSets', () => num_sets);
    data.putIfAbsent('UserID', () => widget.clientID);
    for (int i = 1; i <= num_sets; i++) {
      data.putIfAbsent('Set$i', () => allSets[i - 1]);
    }
    return FirebaseFirestore.instance.collection('User_Workouts').add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Trainer workout view"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: 30,
                width: 100,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: getLoginBorderColor()),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: getLoginBorderColor()),
                    ),
                    labelText: "Set Reps",
                    labelStyle: TextStyle(
                      color: getLoginTextColor(),
                    ),
                  ),
                  onChanged: (value) {
                    try {
                      set_reps = int.parse(value);
                    } catch (error_e) {
                      set_reps = 1;
                    }
                  },
                )),
            if (allSets[num_sets].isEmpty)
              const SizedBox(
                width: 20,
              ),
            Text(printCurrentSet(),
                style: TextStyle(fontSize: 16, color: getButtonTextColor())),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                  height: 30,
                  width: 300,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: getLoginBorderColor()),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: getLoginBorderColor()),
                      ),
                      labelText: "Workout",
                      labelStyle: TextStyle(
                        color: getLoginTextColor(),
                      ),
                    ),
                    onChanged: (value) {
                      exercise = value;
                    },
                  )),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                  height: 30,
                  width: 75,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: getLoginBorderColor()),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: getLoginBorderColor()),
                      ),
                      labelText: "Reps",
                      labelStyle: TextStyle(
                        color: getLoginTextColor(),
                      ),
                    ),
                    onChanged: (value) {
                      reps = value;
                    },
                  )),
            ]),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: addToSet,
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(150, 50), primary: getButtonColor()),
              child: Text("Add to Set",
                  style: TextStyle(fontSize: 22, color: getButtonTextColor()),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: finishSet,
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 50), primary: getButtonColor()),
                child: Text("Finish Set",
                    style: TextStyle(fontSize: 22, color: getButtonTextColor()),
                    textAlign: TextAlign.center),
              ),
              const SizedBox(
                width: 10.0,
              ),
              ElevatedButton(
                onPressed: submitWorkout,
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 50), primary: getButtonColor()),
                child: Text("Finish Workout",
                    style: TextStyle(fontSize: 22, color: getButtonTextColor()),
                    textAlign: TextAlign.center),
              ),
            ]),
            if (workout_submitted)
              FutureBuilder(
                  future: submitWorkout(),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SpinKitWave(
                          color: getButtonTextColor(),
                          size: 50.0,
                        ),
                      );
                    } else {
                      Future.delayed(const Duration(milliseconds: 0)).then(
                          (value) => Navigator.pushNamed(
                              context, "/workout_creation_selection"));
                      workout_submitted = false;
                      return const Text("Added");
                    }
                  }),
          ],
        ),
      ),
    );
  }
}
