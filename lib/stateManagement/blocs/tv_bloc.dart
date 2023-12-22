// ignore_for_file: deprecated_member_use

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/hive/models/hive_media_model.dart';
import 'package:jendela_dbp/hive/models/hive_tv_model.dart';
import 'package:jendela_dbp/stateManagement/events/tv_event.dart';
import 'package:jendela_dbp/stateManagement/states/tv_state.dart';
import 'package:rxdart/rxdart.dart';

class TvBloc extends Bloc<TvEvent, TvState> {
  // News Bloc
  TvBloc() : super(VideoInit());
  int _page = 1;

  @override
  Stream<Transition<TvEvent, TvState>> transformEvents(
      Stream<TvEvent> events,
      TransitionFunction<TvEvent, TvState> transitionFn) {
    final nonDebounceStream = events.where((event) => event is! TvFetch);

    final debounceStream = events
        .where((event) => event is TvFetch)
        .debounceTime(const Duration(milliseconds: 500));
    return super.transformEvents(
        MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  }

  @override
  Stream<TvState> mapEventToState(TvEvent event) async* {
    if (event is TvFetch) {
      yield VideoLoading();
      try {
        _page = 1;
        List<Tv> tvList =
            (await Tv().fetchVideo(_page, event.perPage)) ?? [];
        // fetch video categories
        if (tvList.isNotEmpty) {
          tvList.map((e) async {
            e.tvCategories = await Tv().fetchTvCategories();
            return e;
          });
        }
        yield TvLoaded(
          tv: tvList,
        );
      } catch (e) {
        yield TvError();
      }
    }
    if (event is VideoFetchMore) {
      try {
        List<Tv> tvList =
            (await Tv().fetchVideo(_page + 1, event.perPage)) ?? [];
        if (tvList.isNotEmpty) {
          _page++;
        }
        List<Tv> combinedList = [];
        combinedList.addAll(state.tv ?? []);
        combinedList.addAll(tvList);
        yield VideoLoading();
        yield TvLoaded(tv: combinedList);
      } catch (e) {
        // print(e.toString());
        yield TvError(message: e.toString());
      }
    }
    if (event is VideoCategoriesFetch) {
      // yield VideoCategoriesLoded();
      // await VideoCategory.fetchById(event.mediaId ?? null);
    }
    if (event is VideoMediaFetchById) {
      try {
        // ignore: unused_local_variable
        Media? media = await Media.fetchById(event.mediaId ?? 0);
        // yield VideoLoaded(media: media);
      } catch (e) {
        // yield VideoError();
      }
    }
  }
}
