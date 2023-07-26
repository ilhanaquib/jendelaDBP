import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/model/book_model.dart';

class BookListState {
  final List<BookModel> books;

  BookListState(this.books);
}

abstract class BookListEvent {}

class LoadBookListEvent extends BookListEvent {
  // You can add any parameters you might need for loading the book list
}

class BookListBloc extends Bloc<BookListEvent, BookListState> {
  BookListBloc() : super(BookListState([])) {
    on<LoadBookListEvent>((event, emit) {
      List<BookModel> bookList = BookModel.fetchBookList();
      emit(BookListState(bookList));
    });
  }

}
