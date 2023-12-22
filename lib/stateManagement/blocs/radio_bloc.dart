// ignore_for_file: deprecated_member_use

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/hive/models/hive_media_model.dart';
import 'package:jendela_dbp/stateManagement/events/radio_event.dart';
import 'package:jendela_dbp/stateManagement/states/radio_state.dart';
import 'package:jendela_dbp/hive/models/hive_radio_model.dart';
import 'package:rxdart/rxdart.dart';

class RadioBloc extends Bloc<RadioEvent, RadioState> {
  // News Bloc
  RadioBloc() : super(RadioInit());
  int _pageCount = 1;

  @override
  Stream<Transition<RadioEvent, RadioState>> transformEvents(
      Stream<RadioEvent> events,
      TransitionFunction<RadioEvent, RadioState> transitionFn) {
    final nonDebounceStream = events.where((event) => event is! RadioFetch);

    final debounceStream = events
        .where((event) => event is RadioFetch)
        .debounceTime(const Duration(milliseconds: 500));
    return super.transformEvents(
        MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  }

  @override
  Stream<RadioState> mapEventToState(RadioEvent event) async* {
    if (event is RadioFetch) {
      yield RadioLoading();
      try {
        List<Radio> radios =
            (await Radio().fetchRadio(_pageCount, event.perPage)) ?? [];
        // fetch radio categories
        if (radios.isNotEmpty) {
          radios.map((e) async {
            e.radioCategories = await Radio().fetchRadioCategories();
            return e;
          });
        }
        yield RadioLoaded(radios: radios);
      } catch (e) {
        yield RadioError();
      }
    }
    if (event is RadioFetchMore) {
      try {
        List<Radio> radios =
            (await Radio().fetchRadio(_pageCount + 1, event.perPage)) ?? [];
        if (radios.isNotEmpty) {
          _pageCount++;
        }
        List<Radio> combinedList = [];
        combinedList.addAll(state.radios ?? []);
        combinedList.addAll(radios);
        yield RadioLoading();
        yield RadioLoaded(radios: combinedList);
      } catch (e) {
        // print(e.toString());
        yield RadioError(message: e.toString());
      }
    }
    if (event is RadioMediaFetchById) {
      try {
        // ignore: unused_local_variable
        Media? media = await Media.fetchById(event.mediaId ?? 0);
        // yield RadioLoaded(media: media ?? null);
      } catch (e) {
        // yield RadioError();
      }
    }
  }
}
