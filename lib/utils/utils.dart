import 'dart:math';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class utils {
  static final Random _random = Random.secure();

  static Map<String, dynamic> createCryptoRandomString([int length = 32]) {
    Map<String, dynamic> map = Map<String, String>();
    var bytes = List<int>.generate(length, (i) => _random.nextInt(256));
    map['base'] = hex.encode(bytes);
    map['encoded'] = sha256.convert(bytes).toString();
    return map;
  }
}