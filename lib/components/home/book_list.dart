import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/blocs/book_bloc.dart';

class BookList extends StatelessWidget {
  const BookList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookListBloc, BookListState>(
      builder: (context, state) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: state.books.length,
          itemBuilder: (context, index) {
            final book = state.books[index];
            return Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: GestureDetector(
                onTap: () {
                 Navigator.pushNamed(context, '/bookDetail');
                },
                child: SizedBox(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: SizedBox(
                      height: 300,
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Stack(
                                children: [
                                  Image.asset(
                                    book.imagePath,
                                    height: 230,
                                    fit: BoxFit.fill,
                                  ),
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: const Color.fromARGB(
                                          230, 128, 128, 128),
                                      child: Center(
                                        child: Transform.translate(
                                          offset: const Offset(-2.7, -1.7),
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.favorite_border_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                           Padding(
                            padding: const EdgeInsets.only(
                                top: 7,
                                right:
                                    70.0), // Adjust the left padding as per your preference
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.title,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Color.fromARGB(255, 51, 51, 51),
                                  ),
                                ),
                                Text(
                                  book.author,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color.fromARGB(255, 123, 123, 123),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
