import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: camel_case_types
class Onboard_one extends StatelessWidget {
  const Onboard_one({super.key, required this.controller});

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
                  child: Image.asset('assets/images/onboard1.png')),
            ),
          ),
          const Text(
            'Keep Reading',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Explore the giant world ',
            style: TextStyle(
                fontSize: 15, color: Color.fromARGB(255, 123, 123, 123)),
          ),
          const Text(
            'of different book ',
            style: TextStyle(
                fontSize: 15, color: Color.fromARGB(255, 123, 123, 123)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: const ExpandingDotsEffect(
                    activeDotColor: Color.fromARGB(255, 235, 127, 35),
                    dotColor: Color.fromARGB(255, 123, 123, 123),
                    dotHeight: 8,
                    dotWidth: 8),
                onDotClicked: (index)=>controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
