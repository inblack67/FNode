import 'dart:typed_data';

import 'package:hive/hive.dart';

class MHive {
  static String encryptionBoxName = 'MHIVE';

  static Future<Uint8List> getEncryptionKey() async {
    Box<dynamic> keyBox = await Hive.openBox(encryptionBoxName);
    if (!keyBox.containsKey('key')) {
      List<int> key = Hive.generateSecureKey();
      keyBox.put('key', key);
    }
    Uint8List key = keyBox.get('key') as Uint8List;
    return key;
  }

  static Future<Box<dynamic>> getEncryptionBox(String boxName) async {
    Uint8List key = await getEncryptionKey();
    bool boxAlreadyExists = await Hive.isBoxOpen(boxName);
    Box<dynamic> encryptedBox;
    if (boxAlreadyExists) {
      encryptedBox = await Hive.box(boxName);
      return encryptedBox;
    } else {
      encryptedBox =
          await Hive.openBox(boxName, encryptionCipher: HiveAesCipher(key));
      return encryptedBox;
    }
  }

  static bool addSecret(Box<dynamic> encryptedBox, String key, dynamic value) {
    encryptedBox.put(key, value);
    return true;
  }

  static dynamic getSecret(Box<dynamic> encryptedBox, String key) {
    dynamic value = encryptedBox.get(key);
    return value;
  }
}
