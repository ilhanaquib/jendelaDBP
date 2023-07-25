import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:jendela_dbp/controller/home_controller.dart';
import 'package:jendela_dbp/view/home.dart';
import 'package:jendela_dbp/view/profile.dart';

import 'audiobooks.dart';
import 'saved_books.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (controller.selectedIndex.value) {
          case 0:
            return const Home();
          case 1:
            return const SavedBooks();
          case 2:
            return const Audiobooks();
          case 3:
            return const Profile();
          // Add other cases for additional tabs
          default:
            return Container();
        }
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          items: controller.bottomNavItems
              .map((item) => BottomNavigationBarItem(
                    icon: Stack(
                      children: [
                        Icon(
                          item.iconData,
                          color: controller.selectedIndex.value ==
                                  controller.bottomNavItems.indexOf(item)
                              ? const Color.fromARGB(255, 235, 127, 35)
                              : const Color.fromARGB(255, 123, 123, 123),
                          size: item.iconSize,
                        ),
                        if (controller.selectedIndex.value ==
                            controller.bottomNavItems.indexOf(item))
                          Positioned(
                            left: 13.7,
                            bottom: -5,
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                      ],
                    ),
                    label: item.label,
                  ))
              .toList(),
          currentIndex: controller.selectedIndex.value,
          onTap: (index) => controller.selectTab(index),
        ),
      ),
    );
  }
}
