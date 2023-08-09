import 'package:hive/hive.dart';

part '../adapters/hivePurchasedBookModel.g.dart';

@HiveType(typeId: 2)
class HivePurchasedBook {
  @HiveField(0)
  String? download_id;
  @HiveField(1)
  String? download_url;
  @HiveField(2)
  String? product_name;
  @HiveField(3)
  bool? isDownload;
  @HiveField(4)
  String? downloadUser;
  @HiveField(5)
  String? typeFile;
  @HiveField(6)
  String? bookHistory;
  @HiveField(7)
  bool? isFavorite;
  @HiveField(8)
  String? download_name;
  @HiveField(9)
  int? product_id;
  @HiveField(10)
  int? order_id;
  @HiveField(11)
  String? order_key;
  @HiveField(12)
  String? downloads_remaining;
  @HiveField(13)
  String? access_expires;
  @HiveField(14)
  String? access_expires_gmt;
  @HiveField(15)
  String? download_url_temp;
  @HiveField(16)
  String? localPath;
  @HiveField(17)
  String? featured_media_url;
  @HiveField(18)
  int? parentID;
  @HiveField(19)
  String? descriptionParent;

  @HiveField(20)
  String? product_category;

  @HiveField(21)
  String? IDUser;

  HivePurchasedBook(
      {this.download_id,
      this.download_url,
      this.product_name,
      this.isDownload,
      this.downloadUser,
      this.typeFile,
      this.bookHistory,
      this.isFavorite,
      this.product_id,
      this.download_name,
      this.order_id,
      this.order_key,
      this.downloads_remaining,
      this.access_expires,
      this.access_expires_gmt,
      this.download_url_temp,
      this.localPath,
      this.descriptionParent,
      this.featured_media_url,
      this.parentID,
      this.product_category,
      this.IDUser});

  static HivePurchasedBook fromJson(Map data,
      {typeFile, featured_media_url, IDUser}) {
    return HivePurchasedBook(
        download_id: data['download_id'],
        download_url: data['download_url'],
        product_id: data['product_id'],
        product_name: data['product_name'],
        download_name: data['download_name'],
        order_id: data['order_id'],
        order_key: data['order_key'],
        downloads_remaining: data['downloads_remaining'],
        access_expires: data['access_expires'],
        access_expires_gmt: data['access_expires_gmt'],
        download_url_temp: data['file']['file'],
        typeFile: typeFile,
        localPath: "Tiada",
        isDownload: false,
        bookHistory: "Tiada",
        featured_media_url: featured_media_url,
        parentID: data['parent_product']['id'],
        descriptionParent: data['parent_product']['description'],
        IDUser: IDUser);
  }
}
