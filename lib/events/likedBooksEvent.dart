
abstract class LikedBooksEvent {}

class LikeBookEvent extends LikedBooksEvent {
  final int bookKey;
  LikeBookEvent(this.bookKey);
}

class UnlikeBookEvent extends LikedBooksEvent {
  final int bookKey;
  UnlikeBookEvent(this.bookKey);
}

class DeleteBookEvent extends LikedBooksEvent {
  final int bookKey;
  DeleteBookEvent(this.bookKey);
}
