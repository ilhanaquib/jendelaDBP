import 'package:equatable/equatable.dart';
import 'package:jendela_dbp/hive/models/hive_tv_category_model.dart';
import 'package:jendela_dbp/hive/models/hive_tv_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TvEvent extends Equatable {}

class TvFetch extends TvEvent {
  final List<Tv>? tv;
  final int perPage;
  final int page;
  TvFetch({this.tv, this.perPage = 25, this.page = 1});
  @override
  String toString() => 'Fetch';
  @override
  List<Object> get props => [tv ?? []];
}

class VideoFetchMore extends TvEvent {
  final List<Tv>? tvList;
  final int perPage;
  VideoFetchMore({this.tvList, this.perPage = 25});
  @override
  String toString() => 'Fetch';
  @override
  List<Object> get props => [tvList ?? []];
}

class VideoCategoriesFetch extends TvEvent {
  final List<TvCategory>? tvCategories;
  VideoCategoriesFetch({this.tvCategories});
  @override
  String toString() => 'Fetch Video Categories';
  @override
  List<Object> get props => [tvCategories ?? []];
}

class VideoMediaFetchById extends TvEvent {
  final int? mediaId;
  VideoMediaFetchById({this.mediaId});
  @override
  String toString() => 'Fetch Video Fetured Media';
  @override
  List<Object> get props => [mediaId ?? 0];
}
