// ignore_for_file: must_be_immutable, overridden_fields

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jendela_dbp/hive/models/hive_media_model.dart';
import 'package:jendela_dbp/hive/models/hive_tv_category_model.dart';
import 'package:jendela_dbp/hive/models/hive_tv_model.dart';

abstract class TvState extends Equatable {
  TvState([List props = const []]) : super();
  List<Tv>? tv;
  bool? hasReachedMax;
  List<TvCategory>? tvCategories;
  Media? media;
  TvLoaded copyWith(
      {List<Tv>? tvList,
      Media? media,
      bool? hasReachedMax,
      List<TvCategory>? tvCategories}) {
    return TvLoaded(
        tv: tvList ?? tv,
        tvCategories: tvCategories ?? this.tvCategories,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        media: media ?? this.media);
  }
}

class VideoUninitialized {
  @override
  String toString() => 'VideoUninitialized';
}

class VideoInit extends TvState {
  @override
  List props = [];
}

class TvError extends TvState {
  @override
  List props = [];
  String? message;
  TvError({this.message});
  @override
  String toString() => 'VideoError';
}

@immutable
class TvLoaded extends TvState {
  @override
  List<Tv>? tv;
  @override
  bool? hasReachedMax;
  @override
  List<TvCategory>? tvCategories;
  @override
  Media? media;
  TvLoaded(
      {this.tv, this.hasReachedMax, this.tvCategories, this.media})
      : super();

  @override
  TvLoaded copyWith({
    List<Tv>? tvList,
    List<TvCategory>? tvCategories,
    bool? hasReachedMax,
    Media? media,
  }) {
    return TvLoaded(
        media: media ?? this.media,
        tv: tvList ?? tv,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        tvCategories: tvCategories ?? this.tvCategories);
  }

  @override
  List<Object> get props => [
        media ?? '',
        hasReachedMax ?? false,
        tvCategories ?? [],
        tv ?? []
      ];
}

class VideoLoading extends TvState {
  @override
  List props = [];
}
