import 'dart:convert';

import 'package:hive/hive.dart';

import 'package:jendela_dbp/model/productModel.dart';

part '../adapters/hiveBookModel.g.dart';

@HiveType(typeId: 1)
class HiveBookAPI {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? images;

  @HiveField(3)
  String? description;

  @HiveField(4)
  String? categories;

  @HiveField(5)
  String? regularPrice;

  @HiveField(6)
  String? salePrice;

  @HiveField(7)
  String? dateCreated;

  @HiveField(8)
  String? dateModified;

  @HiveField(9)
  String? averageRating;

  @HiveField(10)
  int? ratingCount;

  @HiveField(11)
  bool? isDownload;

  @HiveField(12)
  String? downloadUser;

  @HiveField(13)
  bool? isFavorite;

  @HiveField(14)
  String? status;

  @HiveField(15)
  String? type;

  @HiveField(16)
  String? woocommerceVariations;

  @HiveField(17)
  int? quantity;

  @HiveField(18)
  String? discountPrice;

  @HiveField(19)
  String? productCategory;

  @HiveField(20)
  String? price;

  @HiveField(21)
  String? sku;

  @HiveField(22)
  String? stockStatus;

  @HiveField(23)
  List? metaData;

  @HiveField(24)
  String? externalUrl;

  @HiveField(25)
  bool? toCheckout;

  @HiveField(26)
  int? buyQuantity;

  @HiveField(27)
  DateTime? timestamp;

  HiveBookAPI(
      {this.id,
      this.name,
      this.images,
      this.description,
      this.categories,
      this.regularPrice,
      this.salePrice,
      this.averageRating,
      this.dateCreated,
      this.dateModified,
      this.ratingCount,
      this.downloadUser,
      this.isDownload,
      this.isFavorite,
      this.status,
      this.type,
      this.woocommerceVariations,
      this.quantity,
      this.discountPrice,
      this.productCategory,
      this.price,
      this.sku,
      this.stockStatus,
      this.metaData,
      this.externalUrl,
      this.toCheckout,
      this.buyQuantity,
      this.timestamp});

  static HiveBookAPI fromJson(Map jsonMap) {
    var imageCheck = "Tiada";
    var tempCategories = "Tiada";
    var productCategoryCheck = "00";
    if (jsonMap['woocommerce']['featured_media_url'].toString() == "" ||
        jsonMap['woocommerce']['featured_media_url'].toString() == "false") {
    } else {
      imageCheck = jsonMap['woocommerce']['featured_media_url'];
    }
    if (jsonMap['woocommerce']['category_ids'].length != 0) {
      productCategoryCheck =
          jsonMap['woocommerce']['category_ids'][0].toString();
    }
    return HiveBookAPI(
        id: jsonMap['woocommerce']['id'],
        name: jsonMap['woocommerce']['name'],
        images: imageCheck,
        description: removeAllHtmlTags(jsonMap['woocommerce']['description']),
        categories: tempCategories,
        regularPrice: jsonMap['woocommerce']['regular_price'],
        salePrice: jsonMap['woocommerce']['sale_price'],
        averageRating: jsonMap['woocommerce']['average_rating'],
        dateCreated: jsonMap['woocommerce']['date_created']['date'],
        dateModified: jsonMap['woocommerce']['date_modified']['date'],
        ratingCount: jsonMap['woocommerce']['rating_count'],
        status: jsonMap['status'],
        type: jsonMap['type'],
        woocommerceVariations: json.encode(jsonMap['woocommerce_variations']),
        productCategory: productCategoryCheck,
        price: jsonMap['woocommerce']['price'],
        sku: jsonMap['woocommerce']['sku'],
        stockStatus: jsonMap['woocommerce']['stock_status'],
        metaData: jsonMap['woocommerce']['meta_data'],
        externalUrl: jsonMap['external_url'],
        timestamp: DateTime.now());
  }

  static HiveBookAPI fromProduct(Product product) {
    String? productCategoryCheck;
    if (product.woocommerce!.categoryIds!.isNotEmpty) {
      productCategoryCheck = product.woocommerce!.categoryIds![0].toString();
    }
    return HiveBookAPI(
      id: product.woocommerce!.id,
      name: product.woocommerce!.name,
      images: product.featuredMediaUrl ?? "Tiada",
      description: removeAllHtmlTags(product.woocommerce!.description ?? ''),
      categories: "Tiada",
      regularPrice: product.woocommerce!.regularPrice,
      salePrice: product.woocommerce!.salePrice,
      averageRating: product.woocommerce!.averageRating,
      dateCreated: product.woocommerce!.dateCreated!['date'],
      dateModified: product.woocommerce!.dateModified!['date'],
      ratingCount: product.woocommerce!.ratingCounts!.length,
      status: product.postStatus,
      type: product.postType,
      woocommerceVariations: json.encode(product.woocommerceVariations),
      productCategory: productCategoryCheck,
      price: product.woocommerce!.price,
      sku: product.woocommerce!.sku,
      stockStatus: product.woocommerce!.stockStatus,
      metaData: product.woocommerce!.metaData,
    );
  }

  static String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }
}
