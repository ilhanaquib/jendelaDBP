import 'package:hive/hive.dart';

part '../adapters/hiveUserBookModel.g.dart';

@HiveType(typeId: 0)
class BookUserModel {
  @HiveField(0)
  final String? bookId;
  @HiveField(1)
  final String? pathEpub;
  @HiveField(2)
  final String? pathPdf;
  @HiveField(3)
  final bool? isDownload;
  @HiveField(4)
  final String? downloadUser;
  @HiveField(5)
  final String? typeFile;
  @HiveField(6)
  final String? bookHistory;
  @HiveField(7)
  bool? isFavorite;

  BookUserModel(
      {this.bookId,
      this.pathEpub,
      this.pathPdf,
      this.isDownload,
      this.downloadUser,
      this.typeFile,
      this.bookHistory,
      this.isFavorite});
}
