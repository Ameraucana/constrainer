import 'dart:convert';
import 'dart:io';
import 'package:constrainer/BaseWidget/MainState.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileIO {
  static Future<File> get _filePath async {
    Directory docs = await getApplicationDocumentsDirectory();
    return File(path.join(docs.path, "constrainer", "save.json"));
  }

  static Future<Map<String, int>> readSave() async {
    File targetPath = await _filePath;
    String raw = await targetPath.readAsString();
    return jsonDecode(raw);
  }

  static void writeSave(MainState state) async {
    File targetPath = await _filePath;
    await targetPath.writeAsString(jsonEncode(state.content));
  }
}
