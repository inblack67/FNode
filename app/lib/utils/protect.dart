import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/hive.dart';

abstract class Protect {
  static Future<bool> allowed({bool authenticated: true}) async {
    final _tokensEncryptionBox =
        await MHive.getEncryptionBox(Constants.tokensEncryptionBoxName);
    var token = await MHive.getSecret(_tokensEncryptionBox, Constants.tokenKey);
    switch (authenticated) {
      case true:
        return token != null ? true : false;
      case false:
        return token == null ? true : false;
      default:
        return false;
    }
  }
}
