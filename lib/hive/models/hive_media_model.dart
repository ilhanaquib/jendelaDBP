import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:jendela_dbp/controllers/global_var.dart';

part '../adapters/hive_media_model.g.dart';

@HiveType(typeId: 9)
class Media {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? date;
  @HiveField(2)
  Map? guid; // guid['rendered']
  @HiveField(3)
  Map? mediaDetails; // sizes -> medium -> source_url;
  @HiveField(4)
  String? mimeType;

  Media({this.id, this.date, this.guid, this.mediaDetails});
  static Media fromJson(Map<String, dynamic> jsonData) {
    return Media(
      id: jsonData['id'],
      date: jsonData['date'],
      guid: jsonData['guid'],
      mediaDetails: _setMediaDetails(jsonData['media_details']),
    );
  }

  static Map _setMediaDetails(Map json) {
    return Map.from(
      {
        "height": json['height'] ,
        "width": json['width'] ,
        "file": json['file'] ,
        "sizes": {
          "full": json['sizes']['full'] ,
          "medium": json['sizes']['medium'] ,
        }
      },
    );
  }

  String? getFullImage() {
    if (mediaDetails == null) {
      return guid!['rendered'];
    }
    return mediaDetails!['sizes']['full'] == null
        ? guid!['rendered']
        : mediaDetails!['sizes']['full']['source_url'];
  }

  String? getMediumImage() {
    if (mediaDetails == null) {
      return guid!['rendered'];
    }
    return mediaDetails!['sizes']['medium'] == null
        ? guid!['rendered']
        : mediaDetails!['sizes']['medium']['source_url'];
  }

  static Future<Media?> fetchById(int id) async {
    Media? media;
    var response = await http
        .get(Uri.https(GlobalVar.baseURLDomain, 'wp-json/wp/v2/media/$id'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      media = Media.fromJson(data);
    }
      return media;
  }
}
