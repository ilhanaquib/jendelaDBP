import 'package:epub_view/epub_view.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jendela_dbp/cubits/AuthCubit.dart';
import 'package:jendela_dbp/model/epub_setting.dart';
import 'package:jendela_dbp/model/productModel.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ProductEvent extends Equatable {}

class ProductFetch extends ProductEvent {
  final List<Product>? products;
  ProductFetch({this.products});
  @override
  String toString() => 'Fetch';
  @override
  List<Object> get props => [products ?? []];
}

class ProductMajalahFetch extends ProductEvent {
  final List<Product>? products;
  ProductMajalahFetch({this.products});
  @override
  String toString() => 'Fetch';
  @override
  List<Object> get props => [products ?? []];
}

class ProductBukuFetch extends ProductEvent {
  final List<Product>? products;
  ProductBukuFetch({this.products});
  @override
  String toString() => 'Fetch';
  @override
  List<Object> get props => [products ?? []];
}

class ProductMediaFetchById extends ProductEvent {
  final int? mediaId;
  ProductMediaFetchById({required this.mediaId});
  @override
  String toString() => 'Fetch Media';
  @override
  List<Object> get props => [mediaId ?? 0];
}

class ProductFetchFromCategory extends ProductEvent {
  final BuildContext context;
  final int categoryId;
  ProductFetchFromCategory({required this.context, required this.categoryId});
  @override
  List<Object> get props => [context, categoryId];
}

class ProductDownloadedFetch extends ProductEvent {
  List props = [];
  final AuthCubit? authCubit;
  ProductDownloadedFetch({this.authCubit});
}

class ProductEpubViewInit extends ProductEvent {
  final List props = [];
  final Download? download;
  final EpubController? epubController;
  final int id;
  final int userId;
  ProductEpubViewInit(
      {required this.id,
      required this.userId,
      this.download,
      this.epubController});
}

class ProductPurchasedBooksFetch extends ProductEvent {
  List props = [];
  BuildContext? context;
  ProductPurchasedBooksFetch({this.context}) : super();
}

class ProductEpubUpdateSetting extends ProductEvent {
  final List props = [];
  final EpubSetting epubSetting;
  final int id;
  final int userId;
  ProductEpubUpdateSetting(
      {required this.epubSetting, required this.id, required this.userId});
}
