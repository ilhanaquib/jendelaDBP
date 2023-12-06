// ignore_for_file: prefer_interpolation_to_compose_strings, unnecessary_string_interpolations

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jendela_dbp/controllers/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> startDownload(
  context,
  myDetailsBook,
  currentUser,
  purchasedBook,
  myBook,
) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  if (Platform.isAndroid) {
    Directory(appDocDir.path.split('Android')[0] + '${Constants.epubPath}')
        .createSync();
  }

  String path = Platform.isIOS
      ? appDocDir.path +
          '/' +
          myDetailsBook.productId.toString() +
          currentUser +
          myDetailsBook.typeFile.toLowerCase()
      : appDocDir.path.split('Android')[0] +
          '${Constants.epubPath}/' +
          myDetailsBook.productId.toString() +
          currentUser +
          myDetailsBook.typeFile.toLowerCase();

  Permission permission = Permission.storage;
  bool isGranted = await permission.isGranted;
  File file = File(path);
  if ((!await file.exists()) && (isGranted)) {
    await file.create();
    // var value = await showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (context) => DownloadAlertDialog(
    //     url: myDetailsBook.downloadUrlTemp,
    //     path: path,
    //   ),
    // );

    //File securePath = await EncryptFile.encryptFile(file);
  } else {
    isGranted = await Permission.storage.request().isGranted;
    if (isGranted) {
      await file.delete();
      await file.create();
      // var value = await showDialog(
      //   barrierDismissible: false,
      //   context: context,
      //   builder: (context) => DownloadAlertDialog(
      //     url: myDetailsBook.downloadUrlTemp,
      //     path: path,
      //   ),
      // );

      //File securePath = await EncryptFile.encryptFile(file);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Akses storan ditolak'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  return true;
}
