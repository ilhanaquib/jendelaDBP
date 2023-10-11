import 'package:flutter/material.dart';

import 'package:jendela_dbp/controllers/dbpColor.dart';

// ignore: must_be_immutable
class AuthForm extends StatelessWidget {
  AuthForm({super.key, required this.fieldName, required this.fieldIcon});

  String fieldName;
  IconData fieldIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                suffixIcon: Icon(
                  fieldIcon,
                  color: const Color.fromARGB(255, 162, 162, 162),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 185, 185, 185),
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                labelText: fieldName,
                labelStyle:  TextStyle(
                  color: DbpColor().jendelaGray,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 185, 185, 185),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 185, 185, 185),
                  ),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
