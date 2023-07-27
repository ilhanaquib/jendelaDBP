import 'package:flutter/material.dart';
import 'package:jendela_dbp/components/user/button.dart';
import 'package:jendela_dbp/components/user/top_header.dart';
import 'package:jendela_dbp/components/user/user_icon.dart';

class User extends StatelessWidget {
  const User({super.key});

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
