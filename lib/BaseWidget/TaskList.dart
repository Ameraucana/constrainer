import 'dart:async';

import 'package:constrainer/BaseWidget/MainState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskList extends StatefulWidget {
  TaskList({Key? key}) : super(key: key);
  @override
  TaskListState createState() => TaskListState();
}

class TaskListState extends State<TaskList> {
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  late Timer timer;
  @override
  Widget build(BuildContext context) {
    return Consumer<MainState>(builder: (context, appState, _) {
      List<Task> tasks = appState.getSortedList();
      if (tasks.length == 0) {
        return Text("There's nothing here");
      } else if (tasks[0].msToDeadline <= 0) {
        return tasks[0].asContainer(appState.renewedTask);
      } else {
        return ListView.separated(
          itemBuilder: (context, index) => tasks[index]
              .asTile(context, appState.renewedTask, appState.remove, appState),
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemCount: tasks.length,
        );
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
