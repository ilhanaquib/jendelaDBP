import 'package:equatable/equatable.dart';
import 'package:jendela_dbp/hive/models/hive_berita_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class BeritaEvent extends Equatable {}

class BeritaFetch extends BeritaEvent {
  final List<Berita>? listOfBerita;
  final int perPage;
  final int page;
  BeritaFetch({this.listOfBerita, this.perPage = 25, this.page = 1});
  @override
  String toString() => 'Fetch';
  @override
  List<Object> get props => [listOfBerita ?? [], perPage, page];
}

class BeritaFetchMore extends BeritaEvent {
  final List<Berita>? listOfBerita;
  final int perPage;
  BeritaFetchMore({this.listOfBerita, this.perPage = 25});
  @override
  String toString() => 'FetchMore';
  @override
  List<Object> get props => [listOfBerita ?? []];
}
