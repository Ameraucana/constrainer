import 'dart:convert';
import 'dart:io';
import 'package:constrainer/BaseWidget/MainState.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileIO {
  static Future<File> get _filePath async {
    Directory docs = await getApplicationDocumentsDirectory();
    return File(path.join(docs.path, "constrainer_data", "save.json"));
  }

  static Future<void> _ensureSaveExists() async {
    File file = await _filePath;
    bool fileExists = await file.exists();
    if (!fileExists) {
      await file.parent.create(recursive: true);
      await file.writeAsString(jsonEncode(<String, int>{}));
    }
  }

  static Future<Map<String, int>> readSave() async {
    await _ensureSaveExists();
    File targetPath = await _filePath;
    String raw = await targetPath.readAsString();
    print(jsonDecode(raw));
    return Map<String, int>.from(jsonDecode(raw));
  }

  static Future<void> writeSave(MainState state) async {
    await _ensureSaveExists();
    File targetPath = await _filePath;
    await targetPath.writeAsString(jsonEncode(state.content));
  }
}
