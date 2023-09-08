import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:hive/hive.dart';

import 'package:jendela_dbp/api-services.dart';
import 'package:jendela_dbp/controllers/globalVar.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';

Box<HiveBookAPI> bookAPIBox = Hive.box<HiveBookAPI>(GlobalVar.APIBook);

Future<Box<HiveBookAPI>> getKategori(context, generateToken, kategori) async {
  // await bookAPIBox.clear();
  String token = generateToken ?? '';
  var queryParameters = {'product_cat': kategori, 'per_page': 50};
  try {
    print('getKategori from try is being called');

    var response = await ApiService.getKategori(token, queryParameters);
    // var jsonConvert = json.decode(response);
    var data = json.decode(response.body);
    print(data);
    if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        width: 200,
        behavior: SnackBarBehavior.floating,
        content: Text('Session Expired. Please login again'),
        duration: Duration(seconds: 1),
      ));
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/Logout', (Route<dynamic> route) => false);
    } else if (response.statusCode == 200) {
      for (int i = 0; i < data.length; i++) {
        HiveBookAPI bookNew = HiveBookAPI.fromJson(data[i]);
        bookAPIBox.add(bookNew);
      }
    }
  } catch (exception, stackTrace) {
    // print(stackTrace.toString());
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
    );
  }
  return bookAPIBox;
}

Future<bool> getBooks() async {
  try {
    print('getBooks from try is being called');

    ApiService.getAllBooks().then((response) {
      // var jsonConvert = json.decode(response);
      var data = json.decode(response.body);
      //print(data);
      if (response.statusCode == 200) {
        for (int i = 0; i < data.length; i++) {
          HiveBookAPI bookNew = HiveBookAPI.fromJson(data[i]);
          bookAPIBox.add(bookNew);
        }
      }
    });
  } catch (exception, stackTrace) {
    // print(stackTrace.toString());
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
    );
  }
  return true;
}
