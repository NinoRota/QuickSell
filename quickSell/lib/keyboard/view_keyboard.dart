import 'package:flutter/material.dart';
import 'package:flutter_plugin_qpos_example/keyboard/view_pwdfield.dart';
import 'key_event.dart';
import 'keyboard_item.dart';

class CustomKeyboard extends StatefulWidget {
  final Function callback;
  final Function initEvent;
  final Function onResult;
  final bool autoBack;
  final double keyHeight;
  final int? pwdField;
  final List<String> keyList;

  const CustomKeyboard({
    required this.callback,
    required this.pwdField,
    required this.initEvent,
    required this.onResult,
    this.autoBack = false,
    this.keyHeight = 48,
    required this.keyList,
  });

  @override
  _CustomKeyboardState createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  late String data;
  late double _screenWidth;
  late double _screenHeight;
  late int keyBoardKeyIndex;
  late StringBuffer buffer;

  @override
  void initState() {
    super.initState();
    data = "";
    keyBoardKeyIndex = 0;
    buffer = StringBuffer();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _screenHeight = mediaQuery.size.height;
    _screenWidth = mediaQuery.size.width;

    print("MediaQueryData   " +
        "_screenHeight:" +
        _screenHeight.toString() +
        "_screenWidth:" +
        _screenWidth.toString());

    print("CustomKeyboard   " +
        "height:" +
        (5 * widget.keyHeight + 180).toString() +
        "_screenWidth:" +
        _screenWidth.toString());

    return Container(
      height: 5 * widget.keyHeight,
      width: double.infinity,
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          keyboardWidget(),
        ],
      ),
    );
  }

  Widget pwdWidget() {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          Align(
            child: IconButton(
              icon: Icon(Icons.close, size: 28),
              onPressed: () => widget.callback(KeyDownEvent("close")),
            ),
            alignment: Alignment.topRight,
          ),
          Container(
            width: double.infinity,
            height: 140,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "请输入支付密码",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Container(
                  width: 250,
                  height: 40,
                  margin: EdgeInsets.only(top: 10),
                  child: CustomPwdField(getPinField()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget keyboardWidget() {
    print("keyboardWidget:build");

    return Container(
      width: double.infinity,
      color: Colors.white,
      height: 5 * widget.keyHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          normalWidget(),
          bottomWidget(),
        ],
      ),
    );
  }

  void onKeyDown(BuildContext context, String text) {
    if ("confirm" == text) {
      widget.onResult(data);
      widget.callback(KeyDownEvent("close"));
      return;
    }
    if ("cancel" == text) {
      widget.callback(KeyDownEvent("close"));
      return;
    }
    if ("del" == text && data.length > 0) {
      setState(() {
        data = data.substring(0, data.length - 1);
      });
    }
    if (data.length >= 6) {
      return;
    }
    setState(() {
      if ("del" != text && text != "commit") {
        data += text;
      }
    });
    if (data.length == 6 && widget.autoBack) {
      widget.onResult(data);
    }
  }

  Widget normalWidget() {
    print("normalWidget:build");
    return Container(
      width: double.infinity,
      color: Colors.white,
      height: 3 * widget.keyHeight,
      child: Wrap(
        children: widget.keyList.sublist(0, 9).map((item) {
          keyBoardKeyIndex++;
          return KeyboardItem(
            parentHeight: 5 * widget.keyHeight,
            drowEvent: onDrowKeyMap,
            keyHeight: widget.keyHeight,
            text: item,
            index: keyBoardKeyIndex,
            callback: (val) => onKeyDown(context, item),
          );
        }).toList(),
      ),
    );
  }

  Widget bottomWidget() {
    print("bottomWidget:build");

    return Container(
      width: double.infinity,
      color: Colors.white,
      height: 2 * widget.keyHeight,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: KeyboardItem(
              parentHeight: 5 * widget.keyHeight,
              drowEvent: onDrowKeyMap,
              keyHeight: widget.keyHeight * 2,
              text: widget.keyList[10],
              index: keyBoardKeyIndex = 10,
              callback: (val) => onKeyDown(context, widget.keyList[10]),
            ),
          ),
          Positioned(
            top: 0,
            left: _screenWidth / 3,
            child: KeyboardItem(
              parentHeight: 5 * widget.keyHeight,
              drowEvent: onDrowKeyMap,
              keyHeight: widget.keyHeight,
              text: widget.keyList[9],
              index: keyBoardKeyIndex = 11,
              callback: (val) => onKeyDown(context, widget.keyList[9]),
            ),
          ),
          Positioned(
            top: widget.keyHeight,
            left: _screenWidth / 3,
            child: KeyboardItem(
              parentHeight: 5 * widget.keyHeight,
              drowEvent: onDrowKeyMap,
              keyHeight: widget.keyHeight,
              text: widget.keyList[11],
              index: keyBoardKeyIndex = 14,
              callback: (val) => onKeyDown(context, widget.keyList[11]),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: KeyboardItem(
              parentHeight: 5 * widget.keyHeight,
              drowEvent: onDrowKeyMap,
              keyHeight: widget.keyHeight * 2,
              text: widget.keyList[12],
              index: keyBoardKeyIndex = 12,
              callback: (val) => onKeyDown(context, widget.keyList[12]),
            ),
          ),
        ],
      ),
    );
  }

  void onDrowKeyMap(value) {
    buffer.write(value);
    var len1 = buffer.length;
    var len2 = widget.keyList.length * 20;
    if (len1 == len2) {
      widget.initEvent(buffer.toString());
    }
  }

  String getPinField() {
    if (widget.pwdField == null) return data;
    if (widget.pwdField == -1) {
      Navigator.pop(context);
    }
    StringBuffer result = StringBuffer();
    int? pwdfield = widget.pwdField ?? 0;
    for (int i = 0; i < pwdfield; i++) {
      result.write(i);
    }
    return result.toString();
  }
}
