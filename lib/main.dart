import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:jendela_dbp/controller/category_controller.dart';

import 'controller/home_controller.dart';

import 'package:jendela_dbp/view/home_view.dart';

void main() {
  runApp(const JendelaDBP());
}

class JendelaDBP extends StatefulWidget {
  const JendelaDBP({super.key});

  @override
  State<JendelaDBP> createState() => _JendelaDBPState();
}

class _JendelaDBPState extends State<JendelaDBP> {
  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    Get.put(CategoryController());
    return  GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 123, 123, 123)),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const HomeView(),
    );
  }
}
