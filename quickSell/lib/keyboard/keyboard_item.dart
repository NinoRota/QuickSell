import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_plugin_qpos_example/Utils.dart';

class KeyboardItem extends StatefulWidget {
  final String text;
  final Function callback;
  final Function drowEvent;
  final double keyHeight;
  final double? keyWidth;
  final double parentHeight;
  final int index;

  const KeyboardItem({
    Key? key,
    required this.drowEvent,
    required this.callback,
    required this.text,
    required this.keyHeight,
    this.keyWidth,
    required this.parentHeight,
    this.index = 0,
  }) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<KeyboardItem> {
  double txtSize = 18;

  @override
  void initState() {
    super.initState();
    if (widget.text == "cancel" || widget.text == "del" || widget.text == "confirm") {
      txtSize = 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var screenWidth = mediaQuery.size.width;
    var screenHeight = mediaQuery.size.height;
    var devicePixelRatio = mediaQuery.devicePixelRatio;
    var keyHeight = widget.keyHeight;
    var keyboardKeyIndex = widget.index;

    int rows = ((keyboardKeyIndex + 2) ~/ 3 - 1);
    int columns = (keyboardKeyIndex - (rows * 3 + 1));

    double leftTopPointX = (screenWidth * devicePixelRatio) / 3 * columns;
    double leftTopPointY = (screenHeight - keyHeight * 5) * devicePixelRatio + keyHeight * devicePixelRatio * rows;
    double rightBottomPointX = leftTopPointX + (screenWidth * devicePixelRatio) / 3;
    double rightBottomPointY = leftTopPointY + keyHeight * devicePixelRatio;

    if (keyboardKeyIndex == 10 || keyboardKeyIndex == 12) {
      rightBottomPointY = leftTopPointY + keyHeight * devicePixelRatio * 2;
    }

    String value = widget.text;
    print("leftTopPointX: ${leftTopPointX.toInt()}   leftTopPointY: ${leftTopPointY.toInt()}   "
        "rightBottomPointX: ${rightBottomPointX.toInt()}   rightBottomPointY: ${rightBottomPointY.toInt()}   value: $value");

    StringBuffer buffer = StringBuffer();
    buffer.write(listAddValue(value == "confirm" ? 15 : value == "del" ? 14 : value == "cancel" ? 13 : int.parse(value)));
    buffer.write(listAddValue(leftTopPointX.toInt()));
    buffer.write(listAddValue(leftTopPointY.toInt()));
    buffer.write(listAddValue(rightBottomPointX.toInt()));
    buffer.write(listAddValue(rightBottomPointY.toInt()));
    widget.drowEvent(buffer.toString());

    if (widget.keyWidth != null) {
      widget.keyWidth = widget.keyWidth!;
    } else {
      widget.keyWidth = screenWidth / 3;
    }

    return Container(
      height: widget.keyHeight,
      width: widget.keyWidth,
      key: GlobalKey(),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            right: 0,
            top: 0,
            left: 0,
            child: OutlinedButton(
              onPressed: onTap,
              child: Text(
                widget.text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: txtSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onTap() {
    widget.callback(widget.text);
  }

  String listAddValue(int value) {
    String result = "0000";
    String string = "";
    var list = List<int>.empty(growable: true)..add(value);
    var fromList = value >= 256 ? Uint16List.fromList(list) : Uint8List.fromList(list);
    string = value >= 256 ? Utils.Uint16ListToHexStr(fromList)! : Utils.Uint8ListToHexStr(fromList)!;
    return result.substring(4 - string.length, 4) + string;
  }
}
