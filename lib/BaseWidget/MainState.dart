import 'package:constrainer/BaseWidget/FileIO.dart';

class MainState {
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
      await FileIO.writeSave(this);
    } else {
      throw "Task by name '$key' does not exist";
    }
  }

  Future<void> add(String name) async {
    content.putIfAbsent(name,
        () => DateTime.now().add(Duration(days: 21)).millisecondsSinceEpoch);
    await FileIO.writeSave(this);
  }
}

class Task {
  Task(MapEntry<String, int> entry)
      : name = entry.key,
        msToDeadline = entry.value - DateTime.now().millisecondsSinceEpoch;
  String name;
  int msToDeadline;
}
