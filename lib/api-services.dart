import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'controllers/globalVar.dart';

class ApiService {
  static Future<dynamic> logMasuk(body) async {
    final response = await http.post(
        Uri.parse(
            'https://${GlobalVar.BaseURLDomain}/wp-json/jwt-auth/v1/token'),
        headers: {"Content-Type": "application/json"},
        body: body);
    return response;
  }

  static Future<Response> register(Object body) async {
    final Response response = await http.post(
        Uri.https(GlobalVar.BaseURLDomain, '/wp-json/jwt-auth/v1/signup'),
        headers: {"Content-Type": "application/json"},
        body: body);
    return response;
  }

  static Future<dynamic> maklumatPengguna(token) async {
    try {
      final response = await http.get(
          Uri.https(GlobalVar.BaseURLDomain, '/wp-json/wp/v2/users/me',
              {"context": "edit"}),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token' 
          });

      return response;
    } catch (er) {
      return null;
    }
  }

  static Future<dynamic> getKategori(token, queryParameters) async {
    try {
      String q = '?';
      queryParameters.forEach((key, value) {
        q += '${key.toString()}=${value == null ? '' : value.toString()}&';
      });
      final response = await http.get(
          Uri.parse(
              'https://${GlobalVar.BaseURLDomain}/wp-json/wp/v2/product$q'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });

      //print('getKategori from api-service is being called');

      return response;
    } catch (er) {
      return null;
    }
  }

  static Future<dynamic> getCategory(token, queryParameters) async {
    try {
      final response = await http.get(
          Uri.parse(
              'https://jendeladbp.my/wp-json/wp/v2/product_cat'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });

      //print('getCategori from api-service is being called');

      return response;
    } catch (er) {
      return null;
    }
  }

  

  static Future<dynamic> getAllBooks() async {
    try {
      final response = await http.get(
          Uri.parse('https://${GlobalVar.BaseURLDomain}/wp-json/wp/v2/product'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });

      //print(response.body);

      return response;
    } catch (er) {
      return null;
    }
  }

  static Future<dynamic> getPurchasedBook(token, queryParameters) async {
    try {
      String q = '?';
      queryParameters.forEach((key, value) {
        q += '${key.toString()}=${value?.toString()}&';
      });
      final response = await http.get(
          Uri.parse(
              'https://${GlobalVar.BaseURLDomain}/wp-json/edbp/v1/downloads$q'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      return response;
    } catch (er) {
      return null;
    }
  }

  static Future<dynamic> addListOfBookToCart(token, jsonPost) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://${GlobalVar.BaseURLDomain}/wp-json/edbp/v1/add-to-cart'),
          headers: {
            'content-type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(jsonPost));

      return response;
    } catch (er) {
      return null;
    }
  }

  static Future<dynamic> getListOfBookInCart(token, queryParameters) async {
    try {
      String q = '?';
      queryParameters.forEach((key, value) {
        q += '${key.toString()}=${value?.toString()}&';
      });
      final response = await http.get(
          Uri.parse(
              'https://${GlobalVar.BaseURLDomain}/wp-json/edbp/v1/cart$q'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      return response;
    } catch (er) {
      return null;
    }
  }

  static Future<dynamic> checkout(token, jsonPost) async {
    try {
      final response = await http.post(
          Uri.parse('https://${GlobalVar.BaseURLDomain}/wp-json/edbp/v1/order'),
          headers: {
            'content-type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(jsonPost));

      return response;
    } catch (er) {
      return null;
    }
  }

  static Future<dynamic> checkoutWc(token, jsonPost) async {
    try {
      final response = await http.post(
          Uri.parse('https://${GlobalVar.BaseURLDomain}/wp-json/wc/v3/orders'),
          headers: {
            'content-type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(jsonPost));

      return response;
    } catch (er) {
      return null;
    }
  }

  static Future<dynamic> createPayment(token, jsonPost) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://${GlobalVar.BaseURLDomain}/wp-json/edbp/v1/payment'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(jsonPost));

      return response;
    } catch (er) {
      return null;
    }
  }

  static Future<dynamic> getArtikel(
      String token, Map<String, dynamic> queryParameters) async {
    try {
      String q = '?';
      queryParameters.forEach((key, value) {
        q += '${key.toString()}=${value?.toString()}&';
      });
      final response = await http.get(
          Uri.parse(
              'https://${GlobalVar.BaseURLDomain}/wp-json/edbp/v1/artikel$q'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            // 'Authorization': token == null ? null : 'Bearer $token',
          });
      return response;
    } catch (e) {
      return null;
    }
  }
}
