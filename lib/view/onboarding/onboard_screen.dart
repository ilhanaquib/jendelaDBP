import 'package:flutter/material.dart';
import 'package:jendela_dbp/view/onboarding/onboard_one.dart';
import 'package:jendela_dbp/view/onboarding/onboard_two.dart';
import 'package:jendela_dbp/view/onboarding/onboard_three.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 2;
            });
          },
          children: [
            Container(
              child: Onboard_one(
                controller: controller,
              ),
            ),
            Container(
              child: Onboard_two(
                controller: controller,
              ),
            ),
            Container(
              child: Onboard_three(
                controller: controller,
                isLastPage: isLastPage,
              ),
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? const SizedBox()
          : Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => controller.jumpToPage(2),
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn),
                    child: const Row(
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.arrow_forward_rounded)
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
