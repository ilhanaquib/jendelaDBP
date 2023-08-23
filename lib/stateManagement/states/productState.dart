import 'package:equatable/equatable.dart';
import 'package:jendela_dbp/model/productModel.dart';
import 'package:hive/hive.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:jendela_dbp/model/epubSetting.dart';

abstract class ProductState extends Equatable {
  const ProductState(
      {this.prodcuts,
      this.hasReachedMax,
      this.downloads,
      this.dataBooks,
      this.bookAPI})
      : super();
  final List<Product>? prodcuts;
  final bool? hasReachedMax;
  final List<Download>? downloads;
  final List<int>? dataBooks;
  final Box<HiveBookAPI>? bookAPI;
}

class ProductUninitialized {
  @override
  String toString() => 'ProductUninitialized';
}

class ProductInit extends ProductState {
  @override
  final List props = [];
}

class ProductError extends ProductState {
  @override
  final List props = [];
  final String? message;
  ProductError({this.message});
  @override
  String toString() => 'ProductError';
}

class ProductLoaded extends ProductState {
  @override
  final List props = [];
  final List<Product>? products;
  @override
  final bool? hasReachedMax;
  @override
  final List<Download>? downloads;
  @override
  final List<int>? dataBooks;
  @override
  final Box<HiveBookAPI>? bookAPI;
  final EpubSetting? epubSetting;

  ProductLoaded(
      {this.products,
      this.hasReachedMax,
      this.downloads,
      this.dataBooks,
      this.bookAPI,
      this.epubSetting});

  @override
  ProductLoaded copyWith(
      {List<Product>? products,
      bool? hasReachedMax,
      List<Download>? downloads,
      List<int>? dataBooks,
      Box<HiveBookAPI>? bookAPI}) {
    return ProductLoaded(
        products: products ?? this.products,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        downloads: downloads ?? this.downloads,
        dataBooks: dataBooks ?? this.dataBooks,
        bookAPI: bookAPI ?? this.bookAPI);
  }
}

class ProductLoading extends ProductState {
  @override
  final List props = [];
}
