import 'dart:typed_data';

import 'package:hive/hive.dart';

class MHive {
  static String encryptionBoxName = 'MHIVE';
  String content;
  MHive({required this.content});

  static Future<Uint8List> getEncryptionKey() async {
    var keyBox = await Hive.openBox(encryptionBoxName);
    if (!keyBox.containsKey('key')) {
      var key = Hive.generateSecureKey();
      keyBox.put('key', key);
    }
    var key = keyBox.get('key') as Uint8List;
    return key;
  }

  static Future<Box<dynamic>> makeEncryptionBox(String boxName) async {
    var key = await getEncryptionKey();
    var encryptedBox =
        await Hive.openBox(boxName, encryptionCipher: HiveAesCipher(key));
    return encryptedBox;
  }

  bool addSecret(Box<dynamic> encryptedBox, String key, String value) {
    encryptedBox.put(key, value);
    return true;
  }

  String getSecret(Box<dynamic> encryptedBox, String key) {
    String value = encryptedBox.get(key);
    return value;
  }
}
