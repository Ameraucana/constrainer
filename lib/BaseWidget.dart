import 'package:flutter/material.dart';

class BaseWidget extends StatefulWidget {
  @override
  BaseWidgetState createState() => BaseWidgetState();
}
class BaseWidgetState extends State<BaseWidget> {

  @override
  Widget build(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
    );
  }
}