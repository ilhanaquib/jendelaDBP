import 'package:flutter/material.dart';

import 'package:jendela_dbp/components/book_list.dart';
import 'package:jendela_dbp/components/bottom_nav_bar.dart';
import 'package:jendela_dbp/components/category_buttons.dart';
import 'package:jendela_dbp/components/top_header_home.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

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
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ListView(
          children: [
            const TopHeader(),
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
                  CategoryButtons()
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
                const SizedBox(height: 300, child: BookList())
              ], // Column Children
            ),
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
                const SizedBox(height: 300, child: BookList())
              ], // Column Children
            ),
          ],
        ),
      ),
    );
  }
}
