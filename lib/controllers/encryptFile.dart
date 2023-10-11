import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:jendela_dbp/controllers/globalVar.dart';

class EncryptFile {
  static Future<File> encryptFile(File file) async {
    File encryptFile = File(file.path + '.dbp');
    try {
      Uint8List encryptInt8List = EncryptFile.encrypt(await file.readAsBytes());
      await encryptFile.writeAsBytes(encryptInt8List.toList());
    } catch (e) {
      // print(e);
    }
    return encryptFile;
  }

  static Future<File> decryptFile(File file) async {
    File decryptFile = File(removeLastCharacter(file.path));
    try {
      Uint8List decryptInt8List =
          EncryptFile.decrypt(await decryptFile.readAsBytes());
      await decryptFile.writeAsBytes(decryptInt8List.toList());
    } catch (e) {
      // print(e);
    }
    return decryptFile;
  }

  static String removeLastCharacter(String str) {
    String? result;
    if ((str.length > 0)) {
      result = str.substring(0, str.length - 4);
    }

    return result ?? '';
  }

  static Uint8List encrypt(Uint8List bytes) {
    final key = Key.fromUtf8(GlobalVar.encrypt_password);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encryptBytes(bytes.toList(), iv: iv);
    // print(encrypted
    //     .base64); // R4PxiU3h8YoIRqVowBXm36ZcCeNeZ4s1OvVBTfFlZRdmohQqOpPQqD1YecJeZMAop/hZ4OxqgC1WtwvX/hP9mw==
    return encrypted.bytes;
  }

  static Uint8List decrypt(Uint8List encryptedBytes) {
    final key = Key.fromUtf8(GlobalVar.encrypt_password);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final decrypted = encrypter.decryptBytes(Encrypted(encryptedBytes), iv: iv);
    // print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
    BytesBuilder bytesBuilder = BytesBuilder();
    for (var i = 0; i < decrypted.length; i++) {
      bytesBuilder.addByte(decrypted[i]);
    }
    return bytesBuilder.toBytes();
  }
}
