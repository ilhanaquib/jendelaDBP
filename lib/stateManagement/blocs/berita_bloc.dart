import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:jendela_dbp/controllers/global_var.dart';
import 'package:jendela_dbp/hive/models/hive_berita_model.dart';
import 'package:jendela_dbp/stateManagement/events/berita_event.dart';
import 'package:jendela_dbp/stateManagement/states/berita_state.dart';
import 'package:rxdart/rxdart.dart';

class BeritaBloc extends Bloc<BeritaEvent, BeritaState> {
  // News Bloc
  BeritaBloc() : super(BeritaInit());
  int _pageCount = 1;
  @override
  Stream<Transition<BeritaEvent, BeritaState>> transformEvents(
      Stream<BeritaEvent> events,
      TransitionFunction<BeritaEvent, BeritaState> transitionFn) {
    // final nonDebounceStream = events.where((event) => event is! BeritaFetch);
    // final debounceStream = events
    //     .where((event) => event is BeritaFetch)
    //     .debounceTime(Duration(milliseconds: 500));
    // return super.transformEvents(
    //     MergeStream([nonDebounceStream, debounceStream]), transitionFn);
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap((transitionFn));
  }

  @override
  Stream<BeritaState> mapEventToState(BeritaEvent event) async* {
    if (event is BeritaInit) {
      _pageCount = 1;
    }
    if (event is BeritaFetch) {
      yield BeritaLoading();
      try {
        _pageCount = 1;
        List<Berita> respData =
            await fetchBerita(perPage: event.perPage, page: _pageCount);
        yield BeritaLoaded(listOfBerita: respData, hasReachedMax: false);
      } catch (e) {
        // print(e.toString());
        yield BeritaError(message: e.toString());
      }
    }
    if (event is BeritaFetchMore) {
      try {
        List<Berita> respData =
            await fetchBerita(perPage: event.perPage, page: _pageCount + 1);
        if (respData.isNotEmpty) {
          _pageCount++;
        }
        List<Berita> combinedList = [];
        combinedList.addAll(state.listOfBerita ?? []);
        combinedList.addAll(respData);
        yield BeritaLoading();
        yield BeritaLoaded(listOfBerita: combinedList);
      } catch (e) {
        // print(e.toString());
        yield BeritaError(message: e.toString());
      }
    }
  }

  Future<List<Berita>> fetchBerita({int perPage = 25, int page = 1}) async {
    final response = await http.get(Uri.parse(
        'https://${GlobalVar.baseURLDomain}/wp-json/edbp/v1/berita?per_page=${perPage.toString()}&page=${page.toString()}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      if (data.isNotEmpty) {
        return data.map((rawBlog) {
          return Berita.fromJson(rawBlog);
        }).toList();
      }
    }
    return [];
  }
}
