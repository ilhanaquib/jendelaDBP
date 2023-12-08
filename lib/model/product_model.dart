import 'package:hive/hive.dart';

import 'package:path/path.dart' as p;

import 'package:jendela_dbp/controllers/global_var.dart';
import 'package:jendela_dbp/hive/models/hive_book_model.dart';

part 'adapters/product_model.g.dart';

@HiveType(typeId: 10)
class Product {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? postAuthor;
  @HiveField(2)
  String? postDate;
  @HiveField(3)
  String? postDateGmt;
  @HiveField(4)
  String? postContent;
  @HiveField(5)
  String? postTitle;
  @HiveField(6)
  String? postExcerpt;
  @HiveField(7)
  String? postStatus;
  @HiveField(8)
  String? commentStatus;
  @HiveField(9)
  String? pingStatus;
  @HiveField(10)
  String? postPassword;
  @HiveField(11)
  String? postName;
  @HiveField(12)
  String? toPing;
  @HiveField(13)
  String? pinged;
  @HiveField(14)
  String? postModified;
  @HiveField(15)
  String? postModifiedGmt;
  @HiveField(16)
  String? postContentFiltered;
  @HiveField(17)
  int? postParent;
  @HiveField(18)
  dynamic guid;
  @HiveField(19)
  int? menuOrder;
  @HiveField(20)
  String? postType;
  @HiveField(21)
  String? postMimeType;
  @HiveField(22)
  String? commentCount;
  @HiveField(23)
  String? filter;
  @HiveField(24)
  List? ancestors;
  @HiveField(25)
  String? pageTemplate;
  @HiveField(26)
  List? postCategory;
  @HiveField(27)
  List? tagsInput;
  @HiveField(28)
  String? featuredMediaUrl;
  @HiveField(29)
  List? woocommerceVariations;
  @HiveField(30)
  WcProduct? woocommerce;

  Product(
      {this.id,
      this.postAuthor,
      this.postDate,
      this.postDateGmt,
      this.postContent,
      this.postTitle,
      this.postExcerpt,
      this.postStatus,
      this.commentStatus,
      this.pingStatus,
      this.postPassword,
      this.postName,
      this.toPing,
      this.pinged,
      this.postModified,
      this.postModifiedGmt,
      this.postContentFiltered,
      this.postParent,
      this.guid,
      this.menuOrder,
      this.postType,
      this.postMimeType,
      this.commentCount,
      this.filter,
      this.ancestors,
      this.postCategory,
      this.tagsInput,
      this.featuredMediaUrl,
      this.woocommerceVariations,
      this.woocommerce});

  static Product fromJson(Map jsonString) {
    return Product(
      id: jsonString['ID'],
      postAuthor: jsonString['post_author'],
      postDate: jsonString['post_date'],
      postDateGmt: jsonString['post_date_gmt'],
      postContent: jsonString['post_content'],
      postTitle: jsonString['post_title'],
      postExcerpt: jsonString['post_excerpt'],
      postStatus: jsonString['post_status'],
      commentStatus: jsonString['comment_status'],
      pingStatus: jsonString['ping_status'],
      postPassword: jsonString['post_password'],
      postName: jsonString['post_name'],
      toPing: jsonString['to_ping'],
      pinged: jsonString['pinged'],
      postModified: jsonString['post_modified'],
      postModifiedGmt: jsonString['post_modified_gmt'],
      postContentFiltered: jsonString['post_content_filtered'],
      postParent: jsonString['post_parent'],
      guid: jsonString['guid'],
      menuOrder: jsonString['menu_order'],
      postType: jsonString['post_type'],
      postMimeType: jsonString['post_mime_type'],
      commentCount: jsonString['comment_count'],
      filter: jsonString['filter'],
      ancestors: jsonString['ancestors'],
      postCategory: jsonString['post_category'],
      tagsInput: jsonString['tags_input'],
      featuredMediaUrl: jsonString['featured_media_url'] == false
          ? null
          : jsonString['featured_media_url'],
      woocommerceVariations: jsonString['woocommerce_variations'],
      woocommerce: WcProduct.fromJson(jsonString['woocommerce']),
    );
  }

  HiveBookAPI getBookAPI() {
    Box<HiveBookAPI> bookFromAPI = Hive.box<HiveBookAPI>(GlobalVar.apiBook);
    List listBooksApi = bookFromAPI.keys.cast<int>().toList();
    HiveBookAPI? bookAPI;
    for (var i = 0; i < listBooksApi.length; i++) {
      int key = listBooksApi[i];
      HiveBookAPI? bookSpecific = bookFromAPI.get(key);
      if (id == bookSpecific!.id) {
        bookAPI = bookSpecific;
      }
    }
    bookAPI ??= toBookAPI();
    return bookAPI;
  }

  HiveBookAPI toBookAPI() {
    final HiveBookAPI data = HiveBookAPI.fromProduct(this);
    return data;
  }
}

class WcProduct {
  int? id;
  String? name;
  String? slug;
  Map? dateCreated;
  Map? dateModified;
  String? status;
  bool? featured;
  String? catalogVisibility;
  String? description;
  String? shortDiscription;
  String? sku;
  String? price;
  String? regularPrice;
  String? salePrice;
  String? dateOnSaleFrom;
  String? dateOnSaleTo;
  int? totalSales;
  String? taxStatus;
  String? taxClass;
  bool? manageStock;
  int? stockQuantity;
  String? stockStatus;
  String? backorders;
  String? lowStockAmount;
  bool? soldIndividually;
  String? weight;
  String? length;
  String? width;
  String? height;
  List? upsellIds;
  List? crossSellIds;
  int? parentId;
  bool? reviewsAllowed;
  String? purchaseNote;
  dynamic attributes;
  dynamic defaultAttributes;
  int? menuOrder;
  String? postPassword;
  bool? virtual;
  bool? downloadable;
  List? categoryIds;
  List? tagIds;
  int? shippingClassId;
  dynamic downloads;
  String? imageId;
  List? galleryImageIds;
  int? downloadLimit;
  int? downloadExpiry;
  List? ratingCounts;
  String? averageRating;
  int? reviewCount;
  List? metaData;

  WcProduct({
    this.id,
    this.name,
    this.slug,
    this.dateCreated,
    this.dateModified,
    this.status,
    this.featured,
    this.catalogVisibility,
    this.description,
    this.shortDiscription,
    this.sku,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.dateOnSaleFrom,
    this.dateOnSaleTo,
    this.totalSales,
    this.taxStatus,
    this.taxClass,
    this.manageStock,
    this.stockQuantity,
    this.stockStatus,
    this.backorders,
    this.lowStockAmount,
    this.soldIndividually,
    this.weight,
    this.length,
    this.width,
    this.height,
    this.upsellIds,
    this.crossSellIds,
    this.parentId,
    this.reviewsAllowed,
    this.purchaseNote,
    this.attributes,
    this.defaultAttributes,
    this.menuOrder,
    this.postPassword,
    this.virtual,
    this.downloadable,
    this.categoryIds,
    this.tagIds,
    this.shippingClassId,
    this.downloads,
    this.imageId,
    this.galleryImageIds,
    this.downloadLimit,
    this.downloadExpiry,
    this.ratingCounts,
    this.averageRating,
    this.reviewCount,
    this.metaData,
  });

  static WcProduct fromJson(Map json) {
    if (json.isEmpty) {
      return WcProduct();
    }
    return WcProduct(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      dateCreated: json['date_created'],
      dateModified: json['date_modified'],
      status: json['status'],
      featured: json['featured'],
      catalogVisibility: json['catalog_visibility'],
      description: json['description'],
      shortDiscription: json['short_discription'],
      sku: json['sku'],
      price: json['price'],
      regularPrice: json['regular_price'],
      salePrice: json['sale_price'],
      dateOnSaleFrom: json['date_on_sale_from'],
      dateOnSaleTo: json['date_on_sale_to'],
      totalSales: json['total_sales'],
      taxStatus: json['tax_status'],
      taxClass: json['tax_slass'],
      manageStock: json['manage_stock'],
      stockQuantity: json['stock_quantity'],
      stockStatus: json['stock_status'],
      backorders: json['backorders'],
      lowStockAmount: json['low_stock_amount'],
      soldIndividually: json['sold_individually'],
      weight: json['weight'],
      length: json['length'],
      width: json['width'],
      height: json['height'],
      upsellIds: json['upsell_ids'],
      crossSellIds: json['cross_sell_ids'],
      parentId: json['parent_id'],
      reviewsAllowed: json['reviews_allowed'],
      purchaseNote: json['purchase_note'],
      attributes: json['attributes'],
      defaultAttributes: json['default_attributes'],
      menuOrder: json['menu_order'],
      postPassword: json['post_password'],
      virtual: json['virtual'],
      downloadable: json['downloadable'],
      categoryIds: json['category_ids'],
      tagIds: json['tag_ids'],
      shippingClassId: json['shipping_class_id'],
      downloads: json['downloads'],
      imageId: json['image_id'],
      galleryImageIds: json['gallery_image_ids'],
      downloadLimit: json['download_limit'],
      downloadExpiry: json['download_expiry'],
      ratingCounts: json['rating_counts'],
      averageRating: json['averageRating'],
      reviewCount: json['review_count'],
      metaData: json['meta_data'],
    );
  }
}

class WcChildren {
  Map? paJenis;

  WcChildren({this.paJenis});

  static WcChildren fromJson(Map jsonSring) {
    return WcChildren(
      paJenis: jsonSring['pa_jenis'],
    );
  }
}

class WcAttributes {
  WcAttributes();

  static WcAttributes fromJson(Map jsonSring) {
    return WcAttributes();
  }
}

class WcVariations {
  WcVariations();

  static WcVariations fromJson(Map jsonSring) {
    return WcVariations();
  }
}

class Download {
  String? downloadId;
  String? downloadUrl;
  int? productId;
  String? productName;
  String? downloadName;
  String? productUrl;
  int? orderId;
  String? orderKey;
  String? downloadsRemaining;
  String? accessExpires;
  String? accessExpiresGmt;
  WcFile? file;
  Map? links;
  String? featuredMediaUrl;
  WcProduct? parentProduct;

  Download(
      {this.downloadId,
      this.downloadUrl,
      this.productId,
      this.productName,
      this.downloadName,
      this.orderId,
      this.orderKey,
      this.downloadsRemaining,
      this.accessExpires,
      this.accessExpiresGmt,
      this.file,
      this.links,
      this.parentProduct,
      this.featuredMediaUrl,
      this.productUrl});

  static Download fromJson(Map json) {
    return Download(
      downloadId: json['download_id'],
      downloadUrl: json['download_url'],
      productId: json['product_id'],
      productName: json['product_name'],
      downloadName: json['download_name'],
      orderId: json['order_id'],
      orderKey: json['order_key'],
      downloadsRemaining: json['downloads_remaining'],
      accessExpires: json['access_expires'],
      accessExpiresGmt: json['access_expires_gmt'],
      file: WcFile.fromJson(json['file']),
      links: json['_links'],
      parentProduct: WcProduct.fromJson(json['parent_product']),
      featuredMediaUrl: json['featured_media_url'],
      productUrl: json['product_url'],
    );
  }

  String getWcFileExt() {
    return file!.file == null || file!.file == ""
        ? ''
        : p.extension(file!.file ?? '');
  }
}

class WcFile {
  String? name;
  String? file;
  WcFile({this.name, this.file});

  static WcFile fromJson(Map json) {
    if (json.isEmpty) {
      return WcFile();
    }
    return WcFile(name: json['name'], file: json['file']);
  }
}
