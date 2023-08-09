import 'package:hive/hive.dart';
import 'dart:convert';
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
  String? regular_price;

  @HiveField(6)
  String? sale_price;

  @HiveField(7)
  String? date_created;

  @HiveField(8)
  String? date_modified;

  @HiveField(9)
  String? average_rating;

  @HiveField(10)
  int? rating_count;

  @HiveField(11)
  bool? isDownload;

  @HiveField(12)
  String? downloadUser;

  @HiveField(13)
  bool? isFavorite = false;

  @HiveField(14)
  String? status;

  @HiveField(15)
  String? type;

  @HiveField(16)
  String? woocommerce_variations;

  @HiveField(17)
  int? quantity;

  @HiveField(18)
  String? discountPrice;

  @HiveField(19)
  String? product_category;

  @HiveField(20)
  String? price;

  @HiveField(21)
  String? sku;

  @HiveField(22)
  String? stock_status;

  @HiveField(23)
  List? meta_data;

  @HiveField(24)
  String? external_url;

  @HiveField(25)
  bool? toCheckout;

  @HiveField(26)
  int? buyQuantity;

  HiveBookAPI(
      {this.id,
      this.name,
      this.images,
      this.description,
      this.categories,
      this.regular_price,
      this.sale_price,
      this.average_rating,
      this.date_created,
      this.date_modified,
      this.rating_count,
      this.downloadUser,
      this.isDownload,
      this.isFavorite,
      this.status,
      this.type,
      this.woocommerce_variations,
      this.quantity,
      this.discountPrice,
      this.product_category,
      this.price,
      this.sku,
      this.stock_status,
      this.meta_data,
      this.external_url,
      this.toCheckout,
      this.buyQuantity});

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
      regular_price: jsonMap['woocommerce']['regular_price'],
      sale_price: jsonMap['woocommerce']['sale_price'],
      average_rating: jsonMap['woocommerce']['average_rating'],
      date_created: jsonMap['woocommerce']['date_created']['date'],
      date_modified: jsonMap['woocommerce']['date_modified']['date'],
      rating_count: jsonMap['woocommerce']['rating_count'],
      status: jsonMap['status'],
      type: jsonMap['type'],
      woocommerce_variations: json.encode(jsonMap['woocommerce_variations']),
      product_category: productCategoryCheck,
      price: jsonMap['woocommerce']['price'],
      sku: jsonMap['woocommerce']['sku'],
      stock_status: jsonMap['woocommerce']['stock_status'],
      meta_data: jsonMap['woocommerce']['meta_data'],
      external_url: jsonMap['external_url'],
    );
  }

    static HiveBookAPI fromProduct(Product product) {
    String? productCategoryCheck;
    if (product.woocommerce!.categoryIds!.length != 0) {
      productCategoryCheck = product.woocommerce!.categoryIds![0].toString();
    }
    return HiveBookAPI(
      id: product.woocommerce!.id,
      name: product.woocommerce!.name,
      images: product.featuredMediaUrl ?? "Tiada",
      description: removeAllHtmlTags(product.woocommerce!.description ?? ''),
      categories: "Tiada",
      regular_price: product.woocommerce!.regularPrice,
      sale_price: product.woocommerce!.salePrice,
      average_rating: product.woocommerce!.averageRating,
      date_created: product.woocommerce!.dateCreated!['date'],
      date_modified: product.woocommerce!.dateModified!['date'],
      rating_count: product.woocommerce!.ratingCounts!.length,
      status: product.postStatus,
      type: product.postType,
      woocommerce_variations: json.encode(product.woocommerceVariations),
      product_category: productCategoryCheck,
      price: product.woocommerce!.price,
      sku: product.woocommerce!.sku,
      stock_status: product.woocommerce!.stockStatus,
      meta_data: product.woocommerce!.metaData,
    );
  }

  static String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }
}
