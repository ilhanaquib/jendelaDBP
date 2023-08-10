import 'package:flutter/material.dart';
import 'package:jendela_dbp/components/bottomNavBar.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: Placeholder(),
    );
  }
}