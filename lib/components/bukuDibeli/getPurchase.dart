import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:path/path.dart' as p;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jendela_dbp/api-services.dart';
import 'package:jendela_dbp/controllers/globalVar.dart';
import 'package:jendela_dbp/hive/models/hivePurchasedBookModel.dart';


Box<HivePurchasedBook> bookPurchaseBox =
    Hive.box<HivePurchasedBook>(GlobalVar.PuchasedBook);

Future<bool> getPurchased(generateToken, context) async {
  String token = generateToken;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userID = prefs.getString('userID');
  // print('ini user ID: ' + userID.toString());

  var queryParameters = {
    'customer': userID.toString(),
  };
  try {
    ApiService.getPurchasedBook(token, queryParameters).then((response) {
    //  var data;

      if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          width: 200,
          behavior: SnackBarBehavior.floating,
          content: Text('Session Expired. Please login again'),
          duration: Duration(seconds: 1),
        ));
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/Logout', (Route<dynamic> route) => false);
      } else if (response.statusCode == 200) {
        List data = json.decode(response.body);
        data = data.reversed.toList();
        for (int i = 0; i < data.length; i++) {
          var formatType = '';
          var images = 'Tiada';

          if (data[i]['featured_media_url'].toString() != "false") {
            images = data[i]['featured_media_url'].toString();
          }

          // var newString = data[i]['file']['name']
          //     .substring(data[i]['file']['name'].length - 3);

          final path = data[i]['file']['file'];

          final newString = p.extension(path).toLowerCase();

          formatType = newString;
          // print("Tajuk: " + data[i]['product_name']);
          // print("formattype: " + formatType);

          // formatType =
          //     await formatType.replaceAll(new RegExp(r"\s+"), "").split(".")[1];
          // print('Format type to saved:' + formatType);
          HivePurchasedBook purchasedBookNew = HivePurchasedBook(
              download_id: data[i]['download_id'],
              download_url: data[i]['download_url'],
              product_id: data[i]['product_id'],
              product_name: data[i]['product_name'],
              download_name: data[i]['download_name'],
              order_id: data[i]['order_id'],
              order_key: data[i]['order_key'],
              downloads_remaining: data[i]['downloads_remaining'],
              access_expires: data[i]['access_expires'],
              access_expires_gmt: data[i]['access_expires_gmt'],
              download_url_temp: data[i]['file']['file'],
              typeFile: formatType,
              localPath: "Tiada",
              isDownload: false,
              bookHistory: "Tiada",
              featured_media_url: images,
              parentID: data[i]['parent_product']['id'],
              descriptionParent: data[i]['parent_product']['description'],
              IDUser: userID.toString());

          bookPurchaseBox.add(purchasedBookNew);
        }
      } else {
        // print("masuk sini");
        throw Exception('Failed to load post');
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

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  return htmlText.replaceAll(exp, '');
}
