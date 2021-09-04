import 'dart:convert';
import 'dart:io';
import 'package:constrainer/BaseWidget/MainState.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class FileIO {
  static const String _endpoint =
      r"https://api.jsonbin.io/v3/b/6133055e0825d31d4ed8a107";

  static Future<String> get _apiKey async {
    return await rootBundle.loadString('assets/api_key');
  }

  static Future<File> get _file async {
    Directory docs = await getApplicationDocumentsDirectory();
    return File(p.join(docs.path, "constrainer_data", "save.json"));
  }

  static Future<void> _ensureSaveExists() async {
    File file = await _file;
    bool fileExists = await file.exists();
    if (!fileExists) {
      await file.parent.create(recursive: true);
      await file.writeAsString(jsonEncode({}));
    }
  }

  static Future<Map<String, dynamic>> readSave() async {
    File file = await _file;

    try {
      Amplify.Storage.downloadFile(key: "SaveFile", local: file);
    } on StorageException catch (e) {
      print("error downloading save file: $e");
    }
    String content = await file.readAsString();
    print("success reading file");

    return Map<String, dynamic>.from(json.decode(content));
  }

  static Future<void> writeSave(MainState state) async {
    await _ensureSaveExists();
    File file = await _file;
    await file.writeAsString(json.encode(state.content));

    try {
      final UploadFileResult result =
          await Amplify.Storage.uploadFile(local: file, key: "SaveFile");
      print("success");
    } on StorageException catch (e) {
      print("error uploading save file: $e");
    }
  }
}
