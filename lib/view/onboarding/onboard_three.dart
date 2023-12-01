import 'package:flutter/material.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types, must_be_immutable
class Onboard_three extends StatelessWidget {
  Onboard_three({super.key, required this.controller, required this.isLastPage});

  // ignore: prefer_typing_uninitialized_variables
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
            'Mudah untuk didengar',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          const SizedBox(
            height: 20,
          ),
           Text(
            'Semua di poket, capai pelbagai ',
            style: TextStyle(
                fontSize: 15, color: DbpColor().jendelaGray,),
          ),
           Text(
            'peranti, di mana-mana ',
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
          isLastPage ? Padding(
            padding: const EdgeInsets.only(top: 70),
            child: SizedBox(
                width: 300,
                height: 50,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side:  BorderSide(
                          color: DbpColor().jendelaOrange,
                        ),
                        backgroundColor: DbpColor().jendelaOrange,
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool('showHome', true);
          
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: const Text(
                      'Mari Mulakan',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),),
              ),
          ) : const SizedBox()
        ],
      ),
    );
  }
}
