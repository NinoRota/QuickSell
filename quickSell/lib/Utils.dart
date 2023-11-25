import 'dart:typed_data';

class Utils {
  static const String hexChars = "0123456789ABCDEF";

  static String? uint8ListToHexStr(Uint8List? list) {
    if (list == null) {
      return null;
    }

    return list.map((byte) => _byteToHex(byte)).join();
  }

  static String? uint16ListToHexStr(Uint16List? list) {
    if (list == null) {
      return null;
    }

    return list.map((value) {
      final hexValue = _valueToHex(value);
      return '$hexValue';
    }).join();
  }

  static bool equals(String value, String other) {
    if (value.length != other.length) {
      return false;
    }

    for (int i = 0; i < value.length; i++) {
      if (value.codeUnitAt(i) != other.codeUnitAt(i)) {
        return false;
      }
    }

    return true;
  }

  static String _byteToHex(int byte) {
    return '${hexChars[(byte & 0xF0) >> 4]}${hexChars[byte & 0x0F]}';
  }

  static String _valueToHex(int value) {
    return '${hexChars[(value & 0xF000) >> 12]}${hexChars[(value & 0x0F00) >> 8]}'
        '${hexChars[(value & 0x00F0) >> 4]}${hexChars[value & 0x000F]}';
  }
}
