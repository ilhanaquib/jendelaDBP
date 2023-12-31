import 'package:flutter/material.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: camel_case_types
class Onboard_two extends StatelessWidget {
  const Onboard_two({super.key, required this.controller});

  // ignore: prefer_typing_uninitialized_variables
  final controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
              child: SizedBox(
                  height: 400,
                  child: Image.asset('assets/images/onboard2.png')),
            ),
          ),
          const Text(
            'Cari Buku Anda',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          const SizedBox(
            height: 20,
          ),
           Text(
            'Temui buku kegemaran ',
            style: TextStyle(
                fontSize: 15, color: DbpColor().jendelaGray,),
          ),
           Text(
            'anda di satu tempat ',
            style: TextStyle(
                fontSize: 15, color: DbpColor().jendelaGray,),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect:  ExpandingDotsEffect(
                    activeDotColor: DbpColor().jendelaOrange,
                    dotColor: DbpColor().jendelaGray,
                    dotHeight: 8,
                    dotWidth: 8),
                onDotClicked: (index) => controller.animateToPage(index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
