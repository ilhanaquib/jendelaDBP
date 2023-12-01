import 'package:hive/hive.dart';

part '../adapters/hivePurchasedBookModel.g.dart';

@HiveType(typeId: 2)
class HivePurchasedBook {
  @HiveField(0)
  String? downloadId;
  @HiveField(1)
  String? downloadUrl;
  @HiveField(2)
  String? productName;
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
  String? downloadName;
  @HiveField(9)
  int? productId;
  @HiveField(10)
  int? orderId;
  @HiveField(11)
  String? orderKey;
  @HiveField(12)
  String? downloadsRemaining;
  @HiveField(13)
  String? accessExpires;
  @HiveField(14)
  String? accessExpiresGmt;
  @HiveField(15)
  String? downloadUrlTemp;
  @HiveField(16)
  String? localPath;
  @HiveField(17)
  String? featuredMediaUrl;
  @HiveField(18)
  int? parentID;
  @HiveField(19)
  String? descriptionParent;

  @HiveField(20)
  String? productCategory;

  @HiveField(21)
  String? idUser;

  HivePurchasedBook(
      {this.downloadId,
      this.downloadUrl,
      this.productName,
      this.isDownload,
      this.downloadUser,
      this.typeFile,
      this.bookHistory,
      this.isFavorite,
      this.productId,
      this.downloadName,
      this.orderId,
      this.orderKey,
      this.downloadsRemaining,
      this.accessExpires,
      this.accessExpiresGmt,
      this.downloadUrlTemp,
      this.localPath,
      this.descriptionParent,
      this.featuredMediaUrl,
      this.parentID,
      this.productCategory,
      this.idUser});

  static HivePurchasedBook fromJson(Map data,
      {typeFile, featuredMediaUrl, idUser}) {
    return HivePurchasedBook(
        downloadId: data['download_id'],
        downloadUrl: data['download_url'],
        productId: data['product_id'],
        productName: data['product_name'],
        downloadName: data['download_name'],
        orderId: data['order_id'],
        orderKey: data['order_key'],
        downloadsRemaining: data['downloads_remaining'],
        accessExpires: data['access_expires'],
        accessExpiresGmt: data['access_expires_gmt'],
        downloadUrlTemp: data['file']['file'],
        typeFile: typeFile,
        localPath: "Tiada",
        isDownload: false,
        bookHistory: "Tiada",
        featuredMediaUrl: featuredMediaUrl,
        parentID: data['parent_product']['id'],
        descriptionParent: data['parent_product']['description'],
        idUser: idUser);
  }
}
