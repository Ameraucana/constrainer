import 'package:constrainer/BaseWidget/MainState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskList extends StatefulWidget {
  TaskList({Key? key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      tileColor: Theme.of(context).cardColor,
      child: Consumer<MainState>(
          builder: (context, appState, _) => ListView(
              children: appState
                  .getSortedList()
                  .map((task) => task.asTile())
                  .toList())),
    );
  }
}
