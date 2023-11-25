import 'package:flutter/cupertino.dart';

class LogUtil {
  static const String separator = "=";
  static const String title = "Yl-Log";
  static const bool isDebug = true;
  static const int limitLength = 800;

  static String get startLine =>
      '$separator$separator$separator$separator$title$separator$separator$separator$separator$separator';

  static String get endLine =>
      '$separator$separator$separator$separator$separator$separator$separator$separator';

  static void d(dynamic obj) {
    if (isDebug) {
      _log(obj.toString());
    }
  }

  static void v(dynamic obj) {
    _log(obj.toString());
  }

  static void _log(String msg) {
    print(startLine);
    _logEmptyLine();
    if (msg.length < limitLength) {
      print(msg);
    } else {
      _segmentationLog(msg);
    }
    _logEmptyLine();
    print(endLine);
  }

  static void _segmentationLog(String msg) {
    var outStr = StringBuffer();
    for (var index = 0; index < msg.length; index++) {
      outStr.write(msg[index]);
      if (index % limitLength == 0 && index != 0) {
        print(outStr);
        outStr.clear();
        var lastIndex = index + 1;
        if (msg.length - lastIndex < limitLength) {
          var remainderStr = msg.substring(lastIndex, msg.length);
          print(remainderStr);
          break;
        }
      }
    }
  }

  static void _logEmptyLine() {
    print("");
  }
}
