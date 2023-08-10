import 'package:flutter/material.dart';

class UserIcon extends StatelessWidget {
  const UserIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Icon(
      Icons.account_circle_outlined,
      size: 400,
      color: Color.fromARGB(255, 123, 123, 123),
    ));
  }
}
