// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:jendela_dbp/model/book_model.dart';
// import 'package:jendela_dbp/blocs/book_bloc.dart';

// // Events
// abstract class SavedBooksEvent {}

// class FetchSavedBooksEvent extends SavedBooksEvent {}

// // States
// abstract class SavedBooksState {}

// class SavedBooksInitialState extends SavedBooksState {}

// class SavedBooksLoadedState extends SavedBooksState {
//   final List<BookModel> savedBooks;

//   SavedBooksLoadedState(this.savedBooks);
// }

// class SavedBooksErrorState extends SavedBooksState {
//   final String errorMessage;

//   SavedBooksErrorState(this.errorMessage);
// }

// // BLoC
// class SavedBooksBloc extends Bloc<SavedBooksEvent, SavedBooksState> {
//   final BookListBloc bookBloc;

//   SavedBooksBloc(this.bookBloc) : super(SavedBooksInitialState());

//   @override
//   Stream<SavedBooksState> mapEventToState(SavedBooksEvent event) async* {
//     if (event is FetchSavedBooksEvent) {
//       try {
//         // Fetch the saved books using BookBloc
//         bookBloc.add(FetchBooksEvent()); // Trigger the FetchBooksEvent
//         yield* bookBloc.stream.map((state) {
//           if (state is BookLoadedState) {
//             return SavedBooksLoadedState(state.books);
//           } else if (state is BookErrorState) {
//             return SavedBooksErrorState(state.errorMessage);
//           } else {
//             return SavedBooksInitialState();
//           }
//         });
//       } catch (e) {
//         yield SavedBooksErrorState('Failed to fetch saved books');
//       }
//     }
//   }
// }
