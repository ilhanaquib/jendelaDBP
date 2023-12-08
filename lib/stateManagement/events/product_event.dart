import 'package:epub_view/epub_view.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jendela_dbp/model/epub_setting.dart';
import 'package:jendela_dbp/model/product_model.dart';
import 'package:jendela_dbp/stateManagement/cubits/auth_cubit.dart';

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

// ignore: must_be_immutable
class ProductDownloadedFetch extends ProductEvent {
  @override
  List props = [];
  final AuthCubit? authCubit;
  ProductDownloadedFetch({this.authCubit});
}

class ProductEpubViewInit extends ProductEvent {
  @override
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

// ignore: must_be_immutable
class ProductPurchasedBooksFetch extends ProductEvent {
  @override
  List props = [];
  BuildContext? context;
  ProductPurchasedBooksFetch({this.context}) : super();
}

class ProductEpubUpdateSetting extends ProductEvent {
  @override
  final List props = [];
  final EpubSetting epubSetting;
  final int id;
  final int userId;
  ProductEpubUpdateSetting(
      {required this.epubSetting, required this.id, required this.userId});
}
