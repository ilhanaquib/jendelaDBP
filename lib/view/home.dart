import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:jendela_dbp/controller/book_controller.dart';
import 'package:jendela_dbp/controller/category_controller.dart';
import 'package:jendela_dbp/view/book_detail.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu_rounded,
            color: Color.fromARGB(255, 123, 123, 123),
            size: 40,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.account_circle_outlined,
                color: Color.fromARGB(255, 123, 123, 123),
                size: 40,
              ))
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ListView(
          children: [
            // hamburger icon and user icon

            // first two text on top of screen
            const Padding(
              padding:
                  EdgeInsets.only(top: 10.0, left: 15, right: 15, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Hello User!',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 123, 123, 123)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'We have some awesome books for you',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 51, 51, 51)),
                  )
                ],
              ),
            ),
            //search bar
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search your favourite book...',
                  labelStyle: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Color.fromARGB(255, 184, 184, 184),
                  ),
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.mic),
                    onPressed: () {},
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 244, 244, 244),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
            ),
            // categories
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    child: Text(
                      'Categories',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          letterSpacing: 1),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 30,
                    child: GetBuilder<CategoryController>(
                      builder: (controller) => ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.categories.length,
                        itemBuilder: (context, index) {
                          final double leftPadding = index == 0 ? 20 : 10;
                          final category = controller.categories[index];
                          return Padding(
                            padding: EdgeInsets.only(left: leftPadding),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: category.isSelected
                                    ? const Color.fromARGB(255, 144, 191, 63)
                                    : Colors.white,
                                side: BorderSide(
                                  color: category.isSelected
                                      ? const Color.fromARGB(255, 144, 191, 63)
                                      : const Color.fromARGB(
                                          255, 236, 236, 236),
                                ),
                              ),
                              onPressed: () {
                                controller.onCategoryPressed(index);
                              },
                              child: Text(
                                category.name,
                                style: TextStyle(
                                  color: category.isSelected
                                      ? Colors.white
                                      : const Color.fromARGB(
                                          255, 123, 123, 123),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // books (new releases)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'New Releases',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            letterSpacing: 1),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View All',
                          style: TextStyle(
                              color: Color.fromARGB(255, 137, 137, 137)),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: GestureDetector(
                    onTap: (){Get.to(const BookDetail());},
                    child: SizedBox(
                      height: 300,
                      child: Obx(
                        () => ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: BookController().books.length,
                          itemBuilder: (context, index) {
                            final book = BookController().books[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 15),
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
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        230, 128, 128, 128),
                                                child: Center(
                                                  child: Transform.translate(
                                                    offset:
                                                        const Offset(-2.7, -1.7),
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        Icons
                                                            .favorite_border_rounded,
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
                                              40.0), // Adjust the left padding as per your preference
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            book.title,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              color:
                                                  Color.fromARGB(255, 51, 51, 51),
                                            ),
                                          ),
                                          Text(
                                            book.author,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color.fromARGB(
                                                  255, 123, 123, 123),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ], // Column Children
            ),
            // books (recommended)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recommended',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            letterSpacing: 1),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View All',
                          style: TextStyle(
                              color: Color.fromARGB(255, 137, 137, 137)),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: GestureDetector(
                    onTap: (){},
                    child: SizedBox(
                      height: 300,
                      child: Obx(
                        () => ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: BookController().books.length,
                          itemBuilder: (context, index) {
                            final book = BookController().books[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 15),
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
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        230, 128, 128, 128),
                                                child: Center(
                                                  child: Transform.translate(
                                                    offset:
                                                        const Offset(-2.7, -1.7),
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        Icons
                                                            .favorite_border_rounded,
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
                                              40.0), // Adjust the left padding as per your preference
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            book.title,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              color:
                                                  Color.fromARGB(255, 51, 51, 51),
                                            ),
                                          ),
                                          Text(
                                            book.author,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color.fromARGB(
                                                  255, 123, 123, 123),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ], // Column Children
            ),
          ],
        ),
      ),
    );
  }
}
