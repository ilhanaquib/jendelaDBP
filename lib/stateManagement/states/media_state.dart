// ignore_for_file: must_be_immutable, overridden_fields

import 'package:equatable/equatable.dart';
import 'package:jendela_dbp/hive/models/hive_media_model.dart';

abstract class MediaState extends Equatable {
  MediaState([List props = const []]) : super();
  List<Media>? medias;
  bool? hasReachedMax;
  Media? media;
  MediaLoaded copyWith(
      {List<Media>? medias, bool? hasReachedMax, Media? media}) {
    return MediaLoaded(
        medias: medias ?? this.medias,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        media: media ?? this.media);
  }
}

class MediaUninitialized {
  @override
  String toString() => 'MediaUninitialized';
}

class MediaInit extends MediaState {
  @override
  List props = [];
}

class MediaError {
  @override
  String toString() => 'MediaError';
}

class MediaLoaded extends MediaState {
  @override
  List props = [];
  @override
  final List<Media>? medias;
  @override
  final bool? hasReachedMax;
  @override
  final Media? media;
  MediaLoaded({this.medias, this.hasReachedMax, this.media})
      : super([medias, hasReachedMax]);

  @override
  MediaLoaded copyWith(
      {List<Media>? medias, bool? hasReachedMax, Media? media}) {
    return MediaLoaded(
        medias: medias ?? this.medias,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        media: media ?? this.media);
  }
}
