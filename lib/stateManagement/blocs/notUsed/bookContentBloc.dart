import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jendela_dbp/model/bookContentModel.dart';

class BookContentState {
  final List<BookContentModel> bookContent;

  BookContentState(this.bookContent);
}

abstract class BookContentEvent {}

class LoadBookContentEvent extends BookContentEvent {
  // You can add any parameters you might need for loading the book list
}

class BookContentBloc extends Bloc<BookContentEvent, BookContentState> {
  BookContentBloc() : super(BookContentState([])) {
    on<LoadBookContentEvent>((event, emit) {
      List<BookContentModel> bookContentList = BookContentModel.fetchBookContent();
      emit(BookContentState(bookContentList));
    });
  }

}
