// ignore_for_file: deprecated_member_use

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/hive/models/hive_media_model.dart';
import 'package:jendela_dbp/stateManagement/events/media_event.dart';
import 'package:jendela_dbp/stateManagement/states/media_state.dart';
import 'package:rxdart/rxdart.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  // News Bloc
  MediaBloc() : super(MediaInit());
  final bool _hasReachedMax = false;

  @override
  Stream<Transition<MediaEvent, MediaState>> transformEvents(
      Stream<MediaEvent> events,
      TransitionFunction<MediaEvent, MediaState> transitionFn) {
    final nonDebounceStream = events.where((event) => event is! MediaFetch);

    final debounceStream = events
        .where((event) => event is MediaFetch)
        .debounceTime(const Duration(milliseconds: 500));
    return super.transformEvents(
        MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  }

  @override
  Stream<MediaState> mapEventToState(MediaEvent event) async* {
    if (event is MediaFetchById) {
      Media? media;
      try {
        media = await Media.fetchById(event.mediaId ?? 0);
        yield MediaLoaded(media: media, hasReachedMax: _hasReachedMax);
      } catch (e) {
        // yield MediaError();
        rethrow;
      }
    }
  }
}
