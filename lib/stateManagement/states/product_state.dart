import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:jendela_dbp/model/epubSetting.dart';
import 'package:jendela_dbp/model/productModel.dart';

abstract class ProductState extends Equatable {
  const ProductState(
      {this.products,
      this.hasReachedMax,
      this.downloads,
      this.dataBooks,
      this.bookAPI})
      : super();
  final List<Product>? products;
  final bool? hasReachedMax;
  final List<Download>? downloads;
  final List<int>? dataBooks;
  final Box<HiveBookAPI>? bookAPI;

  // ProductLoaded copyWith(
  //     {List<Product> products,
  //     bool hasReachedMax,
  //     List<Download> downloads,
  //     List<int> dataBooks}) {
  //   return ProductLoaded(
  //       products: products ?? this.products,
  //       hasReachedMax: hasReachedMax ?? this.hasReachedMax,
  //       downloads: downloads ?? this.downloads,
  //       dataBooks: dataBooks ?? this.dataBooks);
  // }
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
  @override
  // ignore: overridden_fields
  final List<Product>? products;
  @override
  // ignore: overridden_fields
  final bool? hasReachedMax;
  @override
  // ignore: overridden_fields
  final List<Download>? downloads;
  @override
  // ignore: overridden_fields
  final List<int>? dataBooks;
  @override
  // ignore: overridden_fields
  final Box<HiveBookAPI>? bookAPI;
  final EpubSetting? epubSetting;

  ProductLoaded(
      {this.products,
      this.hasReachedMax,
      this.downloads,
      this.dataBooks,
      this.bookAPI,
      this.epubSetting});

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
