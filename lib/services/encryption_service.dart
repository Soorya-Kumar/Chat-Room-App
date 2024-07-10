import 'package:chat_app/services/encryption_contract.dart';
import 'package:encrypt/encrypt.dart';

class EncService implements EncryptionContract {

  static final key = Key.fromLength(32);
  static final _iv = IV.fromLength(8);
 
  final Encrypter _encryptor = Encrypter(Salsa20(key));

  @override
  String encrypt(String plainData) {
    final encrypted = _encryptor.encrypt(plainData, iv:_iv).base64;
    return encrypted;
  }

  @override
  String decrypt(String encData) {
    final encrypted = Encrypted.fromBase64(encData);  
    final decrypted = _encryptor.decrypt(encrypted, iv:_iv);
    return decrypted;
  }

}