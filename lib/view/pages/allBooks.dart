import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'book_detail.dart';

class AllBooks extends StatefulWidget {
  AllBooks(
      {super.key,
      required this.categoryTitle,
      required this.listBook,
      required this.bookBox});

  final String categoryTitle;
  List<int> listBook;
  final Box<HiveBookAPI> bookBox;

  @override
  State<AllBooks> createState() => _AllBooksState();
}

class _AllBooksState extends State<AllBooks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryTitle} Terkini'),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            snap: true,
            elevation: 0.0,
            toolbarHeight: 0.01,
          ),
          SliverFillRemaining(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.6),
              itemCount: widget.listBook.length,
              itemBuilder: (context, index) {
                final int key = widget.listBook[index];
                final HiveBookAPI? bookSpecific = widget.bookBox.get(key);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetail(
                          bookImage: bookSpecific.images!,
                          bookTitle: bookSpecific.name!,
                          bookDesc: bookSpecific.description!,
                        ),
                      ),
                    );
                  },
                  child: Column(
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
                              CachedNetworkImage(
                                imageUrl: bookSpecific!.images!,
                                height: 150,
                                width: 100,
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        bookSpecific.name!,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
