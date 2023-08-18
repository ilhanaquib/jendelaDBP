import 'package:flutter_bloc/flutter_bloc.dart';

class LikedStatusCubit extends Cubit<Map<int, bool>> {
  LikedStatusCubit() : super({});

  void updateLikedStatus(int bookId, bool isLiked) {
    final updatedLikedStatus = state..[bookId] = isLiked;
    emit(updatedLikedStatus);
  }

  void removeLikedStatus(int bookId) {
    final updatedLikedStatus = Map<int, bool>.from(state);
    updatedLikedStatus.remove(bookId); // Remove the entry for unliked book
    emit(updatedLikedStatus);
  }

  bool isBookLiked(int bookId) {
    return state[bookId] ?? false;
  }
}
