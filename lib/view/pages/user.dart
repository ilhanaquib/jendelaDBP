import 'package:flutter/material.dart';
import 'package:jendela_dbp/components/user/button.dart';
import 'package:jendela_dbp/components/user/topHeader.dart';
import 'package:jendela_dbp/components/user/userIcon.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(),
          UserIcon(),
          Button(),
        ],
      ),
    );
  }
}
