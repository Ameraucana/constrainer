import 'package:constrainer/BaseWidget/FileIO.dart';
import 'package:flutter/material.dart';

class MainState with ChangeNotifier {
  Map<String, int> content = {};
  MainState(Map<String, int> fileContent) : content = fileContent;

  List<Task> getSortedList() {
    return content.entries.map((entry) => Task(entry)).toList()
      ..sort((a, b) => a.msToDeadline.compareTo(b.msToDeadline));
  }

  Future<void> renewedTask(String key) async {
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

  Future<void> remove(String name) async {
    content.remove(name);
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

  Container asContainer(void Function(String) renewCallback) {
    return Container(
        color: Colors.red,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("$name is past due (${formatter(-msToDeadline)})."),
              Row(),
              SizedBox(height: 15),
              ElevatedButton(
                child: Text("Renew"),
                onPressed: () => renewCallback(name),
              )
            ]));
  }

  ListTile asTile(void Function(String) renewCallback,
      void Function(String) deleteCallback) {
    List<Color> dangerLevelColors = getDangerLevelColor(msToDeadline);
    return ListTile(
      title: Text(
        name,
        maxLines: 1,
        style: TextStyle(
          color: dangerLevelColors[1],
        ),
      ),
      subtitle: Text(
        formatter(msToDeadline),
        maxLines: 1,
        style:
            TextStyle(color: dangerLevelColors[1], fontWeight: FontWeight.w400),
      ),
      leading: ElevatedButton(
        child: Text("Renew"),
        onPressed: () => renewCallback(name),
      ),
      trailing: OutlinedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white70),
            foregroundColor: MaterialStateProperty.all(Colors.red)),
        child: Text("Delete"),
        onPressed: () => deleteCallback(name),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      tileColor: dangerLevelColors[0],
    );
  }
}

List<Color> getDangerLevelColor(int msToDeadline) {
  if ((msToDeadline / Duration.millisecondsPerDay / 7).floor() >= 2) {
    return [Colors.green, Colors.white];
  } else if ((msToDeadline / Duration.millisecondsPerDay / 7).floor() >= 1) {
    return [Colors.yellow, Colors.black];
  } else {
    return [Colors.red, Colors.white];
  }
}

String formatter(int msToDeadline) {
  int workingMs = msToDeadline;
  int weeks = (workingMs / Duration.millisecondsPerDay / 7).floor();
  workingMs -= weeks * Duration.millisecondsPerDay * 7;

  int days = (workingMs / Duration.millisecondsPerDay).floor();
  workingMs -= days * Duration.millisecondsPerDay;

  int hours = (workingMs / Duration.millisecondsPerHour).floor();
  workingMs -= hours * Duration.millisecondsPerHour;

  int minutes = (workingMs / Duration.millisecondsPerMinute).floor();
  workingMs -= minutes * Duration.millisecondsPerMinute;

  int seconds = (workingMs / Duration.millisecondsPerSecond).floor();

  return "${weeks > 0 ? weeks == 1 ? '$weeks week ' : '$weeks weeks ' : ''}${days > 0 ? days == 1 ? '$days day ' : '$days days ' : ''}${hours > 0 ? hours == 1 ? '$hours hour ' : '$hours hours ' : ''}${minutes > 0 ? minutes == 1 ? '$minutes minute ' : '$minutes minutes ' : ''}${seconds == 1 ? '$seconds second' : '$seconds seconds'}";
}
