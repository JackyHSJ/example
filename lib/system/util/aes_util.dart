
import 'package:encrypt/encrypt.dart';
import '../comm/comm_def.dart';

class AesUtil {
  static String encode({
    String aesKey = aesKey,
    String aesIV = aesIV,
    required String rawData
  }) {
    Key key = Key.fromUtf8(aesKey);
    IV iv = IV.fromBase64(aesIV);
    Encrypter encrypter = Encrypter(AES(key, mode: AESMode.ecb));
    Encrypted encrypted = encrypter.encrypt(rawData, iv: iv);
    return encrypted.base64;
  }
}