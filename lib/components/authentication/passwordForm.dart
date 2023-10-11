import 'package:flutter/material.dart';

import 'package:jendela_dbp/controllers/dbpColor.dart';

// ignore: must_be_immutable
class AuthPasswordForm extends StatefulWidget {
  AuthPasswordForm(
      {super.key, required this.fieldName, });

  String fieldName;

  @override
  State<AuthPasswordForm> createState() => _AuthPasswordFormState();
}

class _AuthPasswordFormState extends State<AuthPasswordForm> {
  bool _passwordVisible = true;
  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              obscureText: _passwordVisible,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color.fromARGB(255, 185, 185, 185)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 185, 185, 185),
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                labelText: widget.fieldName,
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
