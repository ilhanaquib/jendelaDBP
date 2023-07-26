class BookModel {
  final String title;
  final String author;
  final String imagePath;
  final String category;

  BookModel({
    required this.title,
    required this.author,
    required this.imagePath,
    required this.category,
  });

  static List<BookModel> fetchBookList() {
    return [
      BookModel(
        title: "Book 1",
        author: "Author 1",
        imagePath: "assets/images/book 1.jpg",
        category: "Category 1",
      ),
      BookModel(
        title: "Book 2",
        author: "Author 2",
        imagePath: "assets/images/book 1.jpg",
        category: "Category 2",
      ),
      BookModel(
        title: "Book 3",
        author: "Author 3",
        imagePath: "assets/images/book 1.jpg",
        category: "Category 2",
      ),
      BookModel(
        title: "Book 4",
        author: "Author 4",
        imagePath: "assets/images/book 1.jpg",
        category: "Category 2",
      ),
      BookModel(
        title: "Book 5",
        author: "Author 5",
        imagePath: "assets/images/book 1.jpg",
        category: "Category 2",
      ),
      // Add more books here...
    ];
  }
}
