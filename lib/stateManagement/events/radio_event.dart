import 'package:equatable/equatable.dart';
import 'package:jendela_dbp/hive/models/hive_radio_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RadioEvent extends Equatable {}

class RadioFetch extends RadioEvent {
  final List<Radio>? radios;
  final int page;
  final int perPage;
  RadioFetch({this.radios, this.page = 1, this.perPage = 25});
  @override
  String toString() => 'Fetch';
  @override
  List<Object> get props => [radios ?? []];
}

class RadioFetchMore extends RadioEvent {
  final List<Radio>? radios;
  final int perPage;
  RadioFetchMore({this.radios, this.perPage = 25});
  @override
  String toString() => 'Fetch';
  @override
  List<Object> get props => [radios ?? []];
}

class RadioMediaFetchById extends RadioEvent {
  final int? mediaId;
  RadioMediaFetchById({this.mediaId});
  @override
  String toString() => 'Fetch Radio Media';
  @override
  List<Object> get props => [mediaId ?? 0];
}
