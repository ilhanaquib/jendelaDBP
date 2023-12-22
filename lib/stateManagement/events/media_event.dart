import 'package:equatable/equatable.dart';
import 'package:jendela_dbp/hive/models/hive_media_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MediaEvent extends Equatable {}

class MediaFetch extends MediaEvent {
  final List<Media>? medias;
  MediaFetch({this.medias});
  @override
  String toString() => 'Fetch All Media';
  @override
  List<Object> get props => [medias ?? []];
}

class MediaFetchById extends MediaEvent {
  final int? mediaId;
  MediaFetchById({@required this.mediaId});
  @override
  String toString() => 'Fetch Media';
  @override
  List<Object> get props => [mediaId ?? 0];
}
