import 'package:constrainer/BaseWidget/FileIO.dart';
import 'package:constrainer/BaseWidget/MainState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseWidget extends StatefulWidget {
  @override
  BaseWidgetState createState() => BaseWidgetState();
}

class BaseWidgetState extends State<BaseWidget> {
  @override
  Widget build(context) {
    return FutureBuilder(
        future: FileIO.readSave(),
        builder: (context, AsyncSnapshot<Map<String, int>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Provider(
              create: (context) => MainState(snapshot.data!),
              child: Column(
                mainAxisSize: MainAxisSize.min,
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
