import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboard_three extends StatelessWidget {
  Onboard_three({super.key, required this.controller, required this.isLastPage});

  final controller;
  bool isLastPage;

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
                  child: Image.asset('assets/images/onboard3.png')),
            ),
          ),
          const Text(
            'Easy to listen',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'All in your pocket, access any ',
            style: TextStyle(
                fontSize: 15, color: Color.fromARGB(255, 123, 123, 123)),
          ),
          const Text(
            'devices, anywhere ',
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
                onDotClicked: (index) => controller.animateToPage(index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn),
              ),
            ),
          ),
          isLastPage ? Padding(
            padding: const EdgeInsets.only(top: 70),
            child: SizedBox(
                width: 300,
                height: 50,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                          color: Color.fromARGB(255, 235, 127, 35),
                        ),
                        backgroundColor: const Color.fromARGB(255, 235, 127, 35),
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool('showHome', true);
          
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: const Text(
                      'Get Started',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),),
              ),
          ) : const SizedBox()
        ],
      ),
    );
  }
}
