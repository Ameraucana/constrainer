import 'package:constrainer/BaseWidget/FileIO.dart';
import 'package:flutter/material.dart';

class MainState with ChangeNotifier {
  Map<String, int> content = {};
  MainState(Map<String, int> fileContent) : content = fileContent;

  List<Task> getSortedList() {
    return content.entries.map((entry) => Task(entry)).toList()
      ..sort((a, b) => a.msToDeadline.compareTo(b.msToDeadline));
  }

  Future<void> visitedTask(String key) async {
    if (content.containsKey(key)) {
      content[key] =
          DateTime.now().add(Duration(days: 21)).millisecondsSinceEpoch;
      notifyListeners();
      await FileIO.writeSave(this);
    } else {
      throw "Task by name '$key' does not exist";
    }
  }

  Future<void> add(String name) async {
    content.putIfAbsent(name,
        () => DateTime.now().add(Duration(days: 21)).millisecondsSinceEpoch);
    notifyListeners();
    await FileIO.writeSave(this);
  }
}

class Task {
  Task(MapEntry<String, int> entry)
      : name = entry.key,
        msToDeadline = entry.value - DateTime.now().millisecondsSinceEpoch;
  String name;
  int msToDeadline;

  ListTile asTile() {
    String formatter() {
      int workingMs = msToDeadline;
      int weeks = (workingMs / Duration.millisecondsPerDay / 7).floor();
      workingMs -= weeks * Duration.millisecondsPerDay * 7;
      int days = (workingMs / Duration.millisecondsPerDay).floor();
      workingMs -= days * Duration.microsecondsPerDay;

      if (weeks >= 1) {
        return "$weeks weeks $days days";
      } else if (days >= 3) {
        return "$days days";
      }

      int hours = (workingMs / Duration.millisecondsPerHour).floor();
      workingMs -= hours * Duration.millisecondsPerHour;

      if (days >= 1) {
        return "$days days $hours hours";
      } else if (hours >= 1) {
        return "$hours hours";
      }

      int minutes = (workingMs / Duration.millisecondsPerMinute).floor();
      return "$minutes minutes";
    }

    return ListTile(
      title: Text(
        name,
        maxLines: 1,
      ),
      subtitle: Text(
        formatter(),
        maxLines: 1,
      ),
    );
  }
}
