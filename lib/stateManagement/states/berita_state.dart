// ignore_for_file: must_be_immutable, overridden_fields

import 'package:equatable/equatable.dart';
import 'package:jendela_dbp/hive/models/hive_berita_model.dart';

abstract class BeritaState extends Equatable {
  BeritaState();
  List<Berita>? listOfBerita;
  Berita? berita;

  BeritaLoaded copyWith({List<Berita>? listOfBerita, Berita? berita}) {
    return BeritaLoaded(
      listOfBerita: listOfBerita ?? this.listOfBerita,
      berita: berita ?? this.berita,
    );
  }
}

// class BlogUninitialized extends BlogState {
//   final List<Blog> blogs;
//   final bool hasReachedMax;
//   @override
//   String toString() => 'PostUninitialized';
// }

// class BlogError extends BlogState {
//   @override
//   String toString() => 'BlogError';
// }

class BeritaLoaded extends BeritaState {
  @override
  List props = [];
  @override
  final List<Berita>? listOfBerita;
  @override
  final Berita? berita;
  final int page;
  final bool hasReachedMax;
  BeritaLoaded(
      {this.listOfBerita,
      this.berita,
      this.hasReachedMax = false,
      this.page = 1})
      : super();

  @override
  BeritaLoaded copyWith(
      {List<Berita>? listOfBerita,
      Berita? berita,
      bool? hasReachedMax,
      int? page}) {
    return BeritaLoaded(
        listOfBerita: listOfBerita ?? this.listOfBerita,
        berita: berita ?? this.berita,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        page: page ?? this.page);
  }

  @override
  String toString() =>
      'PostLoaded { berita: ${berita.toString()}, listOfBerita: ${listOfBerita.toString()} }';
}

class BeritaInit extends BeritaState {
  @override
  List props = [];
}

class BeritaLoading extends BeritaState {
  @override
  List props = [];
}

class BeritaError extends BeritaState {
  @override
  List props = [];
  String? message;
  BeritaError({this.message});
}
