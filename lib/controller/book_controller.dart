import 'package:get/get.dart';
import 'package:jendela_dbp/model/book_model.dart';

class BookController extends GetxController {
  final books = <BookModel>[
    BookModel(title: 'Book Title 1', author: 'Author 1', imagePath: 'assets/images/book 1.jpg', category: 'novel'),
    BookModel(title: 'Book Title 2', author: 'Author 2', imagePath: 'assets/images/book 1.jpg', category: 'novel'),
    // Add more books as needed
  ].obs;
}