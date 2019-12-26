import 'dart:developer' as developer;
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

  static void log_amp(message) {
    developer.log(message, name: 'amp845');
  }

  static Map<String, dynamic> parseAuthDeeplink(String link) {
    Map<String, dynamic> map = Map<String, dynamic>();

    link = link.replaceFirst(new RegExp(r'^[#]'), '');

    List<String> deeplinkSegments = link.split(new RegExp(r'&'));

    deeplinkSegments.forEach((value) {
      List<String> segmentValue = value.split(new RegExp('='));
      map[segmentValue[0]] = segmentValue[1];
    });

    return map;
  }
}