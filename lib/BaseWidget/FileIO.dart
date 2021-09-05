import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:constrainer/BaseWidget/MainState.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileIO {
  static const String _endpoint =
      r"https://json.psty.io/api_v1/stores/constrainer";

  static Future<String> get _apiKey async {
    return await rootBundle.loadString('assets/api_key');
  }

  static Future<File> get _filePath async {
    Directory docs = await getApplicationDocumentsDirectory();
    return File(path.join(docs.path, "constrainer_data", "save.json"));
  }

  static Future<void> _ensureSaveExists() async {
    File file = await _filePath;
    bool fileExists = await file.exists();
    if (!fileExists) {
      await file.parent.create(recursive: true);
      await file.writeAsString(jsonEncode({}));
    }
  }

  static Future<Map<String, dynamic>> readSave() async {
    late Map<String, dynamic> data;
    try {
      http.Response response = await http
          .get(Uri.parse("$_endpoint"), headers: {"Api-Key": await _apiKey});
      data = json.decode(response.body)['data'];

      // synchronize web with local here so 
      // you don't have to induce it in-app
      await _ensureSaveExists();
      File file = await _filePath;
      file.writeAsString(json.encode(data));
    } catch (e) {
      print("failed to retrieve data from server: $e");
      
      await _ensureSaveExists();
      File file = await _filePath;
      data = json.decode(await file.readAsString());
    }

    print(data);
    return Map<String, dynamic>.from(data);
  }

  static Future<void> writeSave(MainState state) async {
    await _ensureSaveExists();
    File file = await _filePath;
    await file.writeAsString(json.encode(state.content));

    await http.put(Uri.parse(_endpoint),
        headers: {"Content-Type": "application/json", "Api-Key": await _apiKey},
        body: json.encode(state.content));
  }
}
