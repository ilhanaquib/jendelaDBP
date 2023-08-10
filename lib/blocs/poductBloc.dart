import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:jendela_dbp/api-services.dart';
import 'package:jendela_dbp/cubits/AuthCubit.dart';
import 'package:jendela_dbp/components/bukuDibeli/getPurchase.dart';
import 'package:jendela_dbp/controllers/getBooksFromApi.dart';
import 'package:jendela_dbp/controllers/globalVar.dart';
import 'package:jendela_dbp/model/epubSetting.dart';
import 'package:jendela_dbp/model/productModel.dart';
import 'package:jendela_dbp/model/userModel.dart';
import 'package:jendela_dbp/events/productEvent.dart';
import 'package:jendela_dbp/hive/api/apiBookModel.dart';
import 'package:jendela_dbp/hive/models/hivePurchasedBookModel.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:jendela_dbp/states/productState.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  // News Bloc
  ProductBloc() : super(ProductInit());
  int _startIndex = 1;
  int _perPage = 10;
  bool _hasReachedMax = false;

  // @override
  // Stream<Transition<ProductEvent, ProductState>> transformEvents(
  //     Stream<ProductEvent> events,
  //     //TransitionFunction<ProductEvent, ProductState> transitionFn) {
  //   // TODO: implement transformEvents
  //   // return super.transformEvents(events, transitionFn);
  //   // events
  //   //     .debounceTime(Duration(milliseconds: 500))
  //   //     .switchMap((value) => null);
  //   final nonDebounceStream = events.where((event) => event is! ProductFetch);

  //   final debounceStream = events
  //       .where((event) => event is ProductFetch)
  //       .debounceTime(Duration(milliseconds: 500));
  //   return super.transformEvents(
  //       MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  // }

  @override
  // TODO: implement initialState
  // ProductState get initialState => ProductUninitialized();

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is ProductFetch) {
      yield ProductLoading();
      List<Product> products = [];
      final response = await http.get(Uri.https(GlobalVar.BaseURLDomain,
          'wp-json/wp/v2/product', {"per_page": "25"}));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        products = data.map((rawBlog) {
          return Product.fromJson(rawBlog);
        }).toList();
      }
      yield ProductLoaded(products: products);
    }
    if (event is ProductMajalahFetch) {
      yield ProductLoading();
      try {
        List<Product> products = [];
        final response = await http.get(Uri.https(GlobalVar.BaseURLDomain,
            'wp-json/edbp/v1/ujana-majalah', {"per_page": "25"}));
        if (response.statusCode == 200) {
          final data = json.decode(response.body) as List<dynamic>;
          products = data.map((rawProduct) {
            HiveBookAPI bookNew = HiveBookAPI.fromJson(rawProduct);
            bookAPIBox.add(bookNew);
            return Product.fromJson(rawProduct);
          }).toList();
        }
        yield ProductLoaded(products: products);
      } catch (err) {
        ProductError(message: err.toString());
      }
    }

    if (event is ProductBukuFetch) {
      yield ProductLoading();
      List<Product> products = [];
      final response = await http.get(Uri.https(GlobalVar.BaseURLDomain,
          'wp-json/edbp/v1/ujana-buku', {"per_page": "25"}));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        if (data.length > 0) {
          products = data.map((rawBlog) {
            return Product.fromJson(rawBlog);
          }).toList();
        }
      }
      yield ProductLoaded(products: products);
    }

    if (event is ProductDownloadedFetch) {
      yield ProductLoading();
      List<Download> downloads = [];
      // String userId = event.userId.toString();
      AuthCubit? authCubit = event.authCubit;
      User? user = await authCubit!.getUser();
      if (user != null) {
        String userId = user.id.toString();
        String? userToken = user.jwtToken;

        final response = await http.get(
            Uri.https(GlobalVar.BaseURLDomain,
                'wp-json/edbp/v1/downloads?customer=$userId'),
            headers: {"Authorization": "Bearer $userToken"});
        if (response.statusCode == 200) {
          final data = json.decode(response.body) as List<dynamic>;
          downloads = data.map((rawBlog) {
            return Download.fromJson(rawBlog);
          }).toList();
        }
        yield ProductLoaded(downloads: downloads);
      } else {
        yield ProductError(message: 'Auth Fail');
      }
    }

    if (event is ProductFetchFromCategory) {
      yield ProductLoading();
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // Box<BookAPI> bookAPI =
        //   await getKategori(event.context, null, event.categoryId);

        Box<HiveBookAPI> bookAPIBox = Hive.box<HiveBookAPI>(GlobalVar.APIBook);
        String token = prefs.getString('token') ?? '';
        var queryParameters = {
          'product_cat': event.categoryId,
          'page': 1,
          'per_page': 10
        };
        var response = await ApiService.getKategori(token, queryParameters);
        // if fail use cache
        if (response.statusCode == 200) {
          // convert response data into bookAPI
          var data = json.decode(response.body);
          bookAPIBox.clear();
          for (int i = 0; i < data.length; i++) {
            HiveBookAPI bookNew = HiveBookAPI.fromJson(data[i]);
            bookAPIBox.add(bookNew);
          }
          yield ProductLoaded(bookAPI: bookAPIBox);
        } else {
          // fetch cache
          yield ProductLoaded(bookAPI: bookAPIBox);
        }
      } catch (e) {
        yield ProductError(message: e.toString());
      }
    }

    if (event is ProductEpubViewInit) {
      yield ProductLoading();
      try {
        String epubSettingName =
            "${event.id.toString()}USER${event.userId.toString()}EPUB_READER_SETTINGS";
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? epubSettings = prefs.getString(epubSettingName);
        late Map jsonSettings;
        try {
          jsonSettings = json.decode(epubSettings ?? '{}');
        } catch (e) {
          jsonSettings = {};
        }
        yield ProductLoaded(
          epubSetting: EpubSetting(
            cfi: jsonSettings['cfi'] ?? '',
            textSize: jsonSettings['textSize'] ?? 12.0,
            theme: jsonSettings['theme'] ?? 'light',
            bookmarks: jsonSettings['bookmarks'] ?? [],
          ),
        );
      } catch (e) {
        yield ProductError(message: e.toString());
      }
    }

    if (event is ProductEpubUpdateSetting) {
      yield ProductLoading();
      try {
        String epubSettingName =
            "${event.id.toString()}USER${event.userId.toString()}EPUB_READER_SETTINGS";
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String jsonSettings = event.epubSetting.toJson();
        bool isSaved = await prefs.setString(epubSettingName, jsonSettings);
        if (isSaved == true) {
          yield ProductLoaded(epubSetting: event.epubSetting);
        } else {
          yield ProductError(message: "Save Failed");
        }
      } catch (e) {
        yield ProductError(message: e.toString());
      }
    }

    if (event is ProductPurchasedBooksFetch) {
      yield ProductLoading();
      try {
        // get data from cache
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String userID = prefs.getString('userID') ?? '';

        List<int> dataBooks = bookPurchaseBox.keys
            .cast<int>()
            .where((key) => bookPurchaseBox.get(key)!.IDUser == userID)
            .toList();
        dataBooks = dataBooks.reversed.toList();
        if (dataBooks.length > 0) {
          yield ProductLoaded(dataBooks: dataBooks);
        }

        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          // get data from api
          String token = prefs.getString('token') ?? '';
          bool getStatus = false;
          // await bookPurchaseBox.clear();
          // get purchased
          var userID = prefs.getString('userID');
          // print('ini user ID: ' + userID.toString());

          var queryParameters = {
            'customer': userID.toString(),
          };
          String? responseMessage;
          try {
            var response =
                await ApiService.getPurchasedBook(token, queryParameters);
            var data;

            if (response.statusCode == 401) {
              responseMessage = 'Session Expired. Please login again';
            } else if (response.statusCode == 200) {
              data = json.decode(response.body);
              await bookPurchaseBox.clear();
              for (int i = 0; i < data.length; i++) {
                var formatType = '';
                var images = 'Tiada';

                if (data[i]['featured_media_url'].toString() != "false") {
                  images = data[i]['featured_media_url'].toString();
                }

                final path = data[i]['file']['file'];

                final newString = p.extension(path).toLowerCase();

                formatType = newString;
                HivePurchasedBook purchasedBookNew = HivePurchasedBook.fromJson(data[i],
                    typeFile: formatType,
                    featured_media_url: images,
                    IDUser: userID.toString());

                bookPurchaseBox.add(purchasedBookNew);
              }
              getStatus = true;
            } else {
              getStatus = false;
              throw Exception('Failed to load post');
            }
            if (responseMessage != null) {
              getStatus = false;
              yield ProductError(message: responseMessage);
            }
          } catch (exception, stackTrace) {
            getStatus = false;
            yield ProductError(message: exception.toString());
            await Sentry.captureException(
              exception,
              stackTrace: stackTrace,
            );
          }
          if (getStatus == true) {
            dataBooks = bookPurchaseBox.keys
                .cast<int>()
                .where((key) => bookPurchaseBox.get(key)!.IDUser == userID)
                .toList();
            dataBooks = dataBooks.reversed.toList();
          }
        }
        yield ProductLoading();
        yield ProductLoaded(dataBooks: dataBooks);
      } catch (e) {
        yield ProductError(message: e.toString());
      }
    }
  }

  //write to app path
  Future<File> _writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<bool> getPurchased(generateToken, context) async {
    return true;
  }
}