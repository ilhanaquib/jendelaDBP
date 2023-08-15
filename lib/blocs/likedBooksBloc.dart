// liked_books_bloc.dart
import 'package:jendela_dbp/events/likedBooksEvent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikedBooksBloc extends Bloc<LikedBooksEvent, Map<int, bool>> {
  LikedBooksBloc() : super({});

  @override
  Stream<Map<int, bool>> mapEventToState(LikedBooksEvent event) async* {
    if (event is LikeBookEvent) {
      state[event.bookKey] = true;
    } else if (event is UnlikeBookEvent) {
      state[event.bookKey] = false;
    } else if (event is DeleteBookEvent) {
      state.remove(event.bookKey);
    }

    yield Map.from(state);
  }
}
