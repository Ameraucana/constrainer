import 'package:constrainer/BaseWidget/MainState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NewTaskBox extends StatefulWidget {
  NewTaskBox({Key? key}) : super(key: key);

  @override
  _NewTaskBoxState createState() => _NewTaskBoxState();
}

class _NewTaskBoxState extends State<NewTaskBox> {
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<FocusNode>(builder: (context, rootNode, _) {
      MainState appState = Provider.of<MainState>(context);
      return RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event) {
          if (event.logicalKey == LogicalKeyboardKey.enter &&
              _textEditingController.text.isNotEmpty) {
            setState(() {
              appState.add(_textEditingController.text);
              _textEditingController.text = "";
            });
            rootNode.requestFocus();
          } else if (event.logicalKey == LogicalKeyboardKey.escape) {
            setState(() {
              _textEditingController.text = "";
            });
            rootNode.requestFocus();
          }
        },
        child: TextField(
          focusNode: FocusNode(),
          controller: _textEditingController,
          decoration: InputDecoration(hintText: "Name of new task"),
          maxLines: 1,
        ),
      );
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
