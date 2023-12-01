import 'package:flutter/material.dart';

class GlobalVar {
  static String baseURLDomain = "jendeladbp.my";
  static String youtubeApiKey = "AIzaSyBCl6GoCXkCQOd5YAMUWccq-OA2Actv4_8";
  static String appVersion = 'Versi 2.6.2';

  static String appleSigninHost = 'jendeladbp.my';
  static String appleSigninPath = '/wp-json/jwt-auth/v1/apple-signin-new';
  static String appleSigninClientId = 'com.jendeladbp.mobilebookreader';
  static String appleSigninClientId2 = 'my.jendeladbp.mobilebookreader';
  static String appleSigninRedirectUri2 =
      "https://jendeladbp.my/wp-json/jwt-auth/v1/apple-signin-new";
  static String appleSigninRedirectUri =
      "https://jendeladbp.my/wp-json/jwt-auth/v1/apple-signin";

  static String apiBook = "APIBook";
  static String localBook = "LocalBook";
  static String puchasedBook = "PurchasedBook";
  static String toCartBook = "ToCart";
  static String userAddress = "UserAddress";
  static String apiBerita = "APIBerita";
  static String localBerita = "LocalBerita";
  static String localFile = "LocalFile";
  static String encryptPassword = "82Fb8c4XgXj3dhKm8GUNUng61lxUDL6V";
  static String favoriteBook = "FavoriteBook";

  static String dewanBahasaId = "2";
  static String dewanSasteraId = "3";
  static String dewanMasyarakatId = "4";
  static String dewanBudayaId = "5";
  static String dewanEkonomiId = "6";
  static String dewanKosmikiId = "7";
  static String dewanTamadunIslamId = "8";
  static String tunasCiptaId = "9";

  static String kategori1 = "908";
  static String kategori2 = "660";
  static String kategori3 = "687";
  static String kategori4 = "667";
  static String kategori5 = "661";
  static String kategori6 = "663";
  static String kategori7 = "669";
  static String kategori8 = "664";
  static String kategori9 = "658";
  static String kategori10 = "659";
  static String kategori11 = "666";
  static String kategori12 = "668";
  static String kategori13 = "665";
  static String kategori14 = "662";
  static String kategori15 = "582";
  static String kategori16 = "655";

  static String kategori1Title = "Cerpen";
  static String kategori2Title = "Bahasa";
  static String kategori3Title = "Biografi";
  static String kategori4Title = "Buku Teks";
  static String kategori5Title = "Novel";
  static String kategori6Title = "Sejarah";
  static String kategori7Title = "Edisi Malaysia Membaca";
  static String kategori8Title = "Islam";
  static String kategori9Title = "Judul Terpilih";
  static String kategori10Title = "Kamus";
  static String kategori11Title = "Kanak-kanak";
  static String kategori12Title = "Lain-lain";
  static String kategori13Title = "Pendidikan";
  static String kategori14Title = "Sastera";
  static String kategori15Title = "Majalah"; //Dewan Ekonomi
  static String kategori16Title = "Majalah"; //Dewan Bahasa

  static String tiadaInternet =
      "Tiada sambungan internet: Menggunakan data lama";

  static String daftarKeluarBuku =
      "Pilih minimum satu buku untuk daftar keluar";

  static Color titleColor1 = Colors.blue;

  static List<Map> wcAddressNegeriList = [
    {"value": "JHR", "text": "Johor"},
    {"value": "KDH", "text": "Kedah"},
    {"value": "KTN", "text": "Kelantan"},
    {"value": "LBN", "text": "Labuan"},
    {"value": "MLK", "text": "Melaka"},
    {"value": "NSN", "text": "Negeri Sembilan"},
    {"value": "PHG", "text": "Pahang"},
    {"value": "PNG", "text": "Pulau Pinang"},
    {"value": "PRK", "text": "Perak"},
    {"value": "PLS", "text": "Perlis"},
    {"value": "SBH", "text": "Sabah"},
    {"value": "SWK", "text": "Sarawak"},
    {"value": "SGR", "text": "Selangor"},
    {"value": "TRG", "text": "Terengganu"},
    {"value": "PJY", "text": "Putrajaya"},
    {"value": "KUL", "text": "Kuala Lumpur"}
  ];

  static String getTitleForCategory(int index) {
    switch (index) {
      case 1:
        return kategori1Title;
      case 2:
        return kategori2Title;
      case 3:
        return kategori3Title;
      case 4:
        return kategori4Title;
      case 5:
        return kategori5Title;
      case 6:
        return kategori6Title;
      case 7:
        return kategori7Title;
      case 8:
        return kategori8Title;
      case 9:
        return kategori9Title;
      case 10:
        return kategori10Title;
      case 11:
        return kategori11Title;
      case 12:
        return kategori12Title;
      case 13:
        return kategori13Title;
      case 14:
        return kategori14Title;
      case 15:
        return kategori15Title;
      case 16:
        return kategori16Title;
      default:
        return 'All';
    }
  }
  // static List<String> categoryIds = [
  //   kategori1,
  //   kategori2,
  //   kategori3,
  //   kategori4,
  //   kategori5,
  //   kategori6,
  //   kategori7,
  //   kategori8,
  //   kategori9,
  //   kategori10,
  //   kategori11,
  //   kategori12,
  //   kategori13,
  //   kategori14,
  //   kategori15,
  //   kategori16,
  // ];

  // static List<String> categoryTitles = [
  //   kategori1Title,
  //   kategori2Title,
  //   kategori3Title,
  //   kategori4Title,
  //   kategori5Title,
  //   kategori6Title,
  //   kategori7Title,
  //   kategori8Title,
  //   kategori9Title,
  //   kategori10Title,
  //   kategori11Title,
  //   kategori12Title,
  //   kategori13Title,
  //   kategori14Title,
  //   kategori15Title,
  //   kategori16Title,
  // ];
}
