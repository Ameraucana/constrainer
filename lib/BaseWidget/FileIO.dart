import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:constrainer/BaseWidget/MainState.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class FileIO {
  static const String _endpoint =
      r"https://api.jsonbin.io/v3/b/6133055e0825d31d4ed8a107";

  static Future<String> get _apiKey async {
    return await rootBundle.loadString('assets/api_key');
  }

  static Future<Map<String, dynamic>> readSave() async {
    print(await _apiKey);
    http.Response response = await http.get(Uri.parse("$_endpoint/latest"),
        headers: {"X-Master-Key": await _apiKey, "X-Bin-Meta": "false"});
    print(response);
    return Map<String, dynamic>.from(json.decode(response.body));
  }

  static Future<void> writeSave(MainState state) async {
    await http.put(Uri.parse(_endpoint),
        headers: {
          "Content-Type": "application/json",
          "X-Master-Key": await _apiKey
        },
        body: json.encode(state.content));
  }
}
