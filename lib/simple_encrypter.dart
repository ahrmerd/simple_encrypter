library simple_encrypter;

import 'dart:io';

import 'package:simple_encrypter/xor_encrypt.dart';

class SimpleEncryptor {
  static Future<void> encrypt(File file, String key,
      [bool replace = true]) async {
    final filename = file.path.split(Platform.pathSeparator).last;
    final parentdir = file.parent.path;
    if (!replace) {
      file = await file.copy(parentdir +
          Platform.pathSeparator +
          XOR.encrypt(filename.codeUnits, key).join('-'));
    } else {
      file = await file.rename(parentdir +
          Platform.pathSeparator +
          XOR.encrypt(filename.codeUnits, key).join('-'));
    }

    if ((await file.length()) < 5) {
      final contents = await file.readAsBytes();
      file.writeAsBytes(XOR.encrypt(contents, key));
    } else {
      var raFile = await file.open(mode: FileMode.append);
      raFile = await raFile.setPosition(0);
      final strtcont = await raFile.read(4);
      final encrypted = XOR.encrypt(strtcont, key);
      raFile = await raFile.setPosition(0);
      await raFile.writeFrom(encrypted);
      await raFile.close();
    }

    // file.rename(parentdir +
    //     Platform.pathSeparator +
    //     XOR.encrypt(filename.codeUnits, key).join('-'));
  }

  static Future<void> decrypt(File file, String key,
      [bool replace = true]) async {
    final filename = file.path.split(Platform.pathSeparator).last;
    final parentdir = file.parent.path;
    if (!replace) {
      file = await file.copy(parentdir +
          Platform.pathSeparator +
          XOR.encrypt(filename.codeUnits, key).join('-'));
    } else {
      file = await file.rename(parentdir +
          Platform.pathSeparator +
          XOR.encrypt(filename.codeUnits, key).join('-'));
    }
    if ((await file.length()) < 5) {
      final contents = await file.readAsBytes();
      file.writeAsBytes(XOR.decrypt(contents, key));
    } else {
      var raFile = await file.open(mode: FileMode.append);
      raFile = await raFile.setPosition(0);
      final strtcont = await raFile.read(4);
      final decrypted = XOR.decrypt(strtcont, key);
      raFile = await raFile.setPosition(0);
      await raFile.writeFrom(decrypted);
      await raFile.close();
    }

    // file.rename(parentdir +
    //     Platform.pathSeparator +
    //     String.fromCharCodes(XOR.decrypt(
    //         filename.split('-').map((e) => int.parse(e)).toList(), key)));
  }
}
