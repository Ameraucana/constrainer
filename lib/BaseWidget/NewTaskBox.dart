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
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _termTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FocusNode _nameNode = FocusNode(), _termNode = FocusNode();
    return Consumer<FocusNode>(builder: (context, rootNode, _) {
      MainState appState = Provider.of<MainState>(context);
      return RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event) {
          if (event.logicalKey == LogicalKeyboardKey.enter &&
              _nameTextController.text.isNotEmpty) {
            setState(() {
              appState.add(_nameTextController.text,
                  int.tryParse(_termTextController.text) ?? 21);
              _nameTextController.text = "";
              _termTextController.text = "";
            });
            rootNode.requestFocus();
          } else if (event.logicalKey == LogicalKeyboardKey.escape) {
            setState(() {
              _nameTextController.text = "";
            });
            rootNode.requestFocus();
          } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
            setState(() {
              _nameTextController.text = "";
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).cardColor),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _nameNode,
                    controller: _nameTextController,
                    decoration: InputDecoration(hintText: "Name of new task"),
                    onTap: () => _nameNode.requestFocus(),
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: TextField(
                    focusNode: _termNode,
                    controller: _termTextController,
                    decoration: InputDecoration(
                        hintText: "Day count to deadline (default is 21)"),
                    onTap: () => _termNode.requestFocus(),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    super.dispose();
  }
}
