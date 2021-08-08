import 'package:constrainer/BaseWidget/FileIO.dart';
import 'package:constrainer/BaseWidget/MainState.dart';
import 'package:constrainer/BaseWidget/NewTaskBox.dart';
import 'package:constrainer/BaseWidget/TaskList.dart';
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
          if (snapshot.connectionState == ConnectionState.done) {
            return ChangeNotifierProvider(
              create: (context) => MainState(snapshot.data!),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NewTaskBox(),
                    Expanded(child: TaskList()),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
