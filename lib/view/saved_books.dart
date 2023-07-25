import 'package:flutter/material.dart';

import 'package:jendela_dbp/controller/book_controller.dart';

class SavedBooks extends StatelessWidget {
  const SavedBooks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Saved Books')),
      ),
      body: ListView.builder(
        itemCount: BookController().books.length,
        itemBuilder: (context, index) {
          final book = BookController().books[index];
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.94,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25, left: 10, right: 10),
              child: Card(
                elevation: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.width * 0.27,
                      child: Card(
                        elevation: 4,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child:
                                Image.asset(book.imagePath, fit: BoxFit.cover)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            book.author,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 123, 123, 123),fontSize: 14),
                          ),
                          const SizedBox(
                            height: 70,
                          ),
                          _buildCategoryBox(
                              capitalizeFirstLetter(book.category))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 100, top: 40),
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.delete_outline_rounded, size: 32,)),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }
}

Widget _buildCategoryBox(String category) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 144, 191, 63),
      borderRadius: BorderRadius.circular(50),
    ),
    child: Text(
      category,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  );
}
