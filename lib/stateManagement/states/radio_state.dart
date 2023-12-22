// ignore_for_file: must_be_immutable, overridden_fields

import 'package:equatable/equatable.dart';
import 'package:jendela_dbp/hive/models/hive_media_model.dart';
import 'package:jendela_dbp/hive/models/hive_radio_category_model.dart';
import 'package:jendela_dbp/hive/models/hive_radio_model.dart';

abstract class RadioState extends Equatable {
  RadioState([List props = const []]) : super();
  List<Radio>? radios;
  bool? hasReachedMax;
  List<RadioCategory>? radioCategories;
  Media? media;
  RadioLoaded copyWith(
      {List<Radio>? radios,
      Media? media,
      bool? hasReachedMax,
      List<RadioCategory>? radioCategories}) {
    return RadioLoaded(
        radios: radios ?? this.radios,
        radioCategories: radioCategories ?? this.radioCategories,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        media: media ?? this.media);
  }
}

class RadioUninitialized {
  @override
  String toString() => 'RadioUninitialized';
}

class RadioError extends RadioState {
  @override
  List props = [];
  String? message;
  RadioError({this.message});
  @override
  String toString() => 'RadioError';
}

class RadioLoaded extends RadioState {
  @override
  List<Radio>? radios;
  @override
  bool? hasReachedMax;
  @override
  List<RadioCategory>? radioCategories;
  @override
  Media? media;
  RadioLoaded(
      {this.radios, this.hasReachedMax, this.radioCategories, this.media})
      : super();

  @override
  RadioLoaded copyWith({
    List<Radio>? radios,
    List<RadioCategory>? radioCategories,
    bool? hasReachedMax,
    Media? media,
  }) {
    return RadioLoaded(
        media: media ?? this.media,
        radios: radios ?? this.radios,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        radioCategories: radioCategories ?? this.radioCategories);
  }

  @override
  List<Object> get props => [
        media ?? '',
        radios ?? [],
        hasReachedMax ?? false,
        radioCategories ?? []
      ];
}

class RadioLoading extends RadioState {
  @override
  List props = [];
}

class RadioInit extends RadioState {
  @override
  List props = [];
}
