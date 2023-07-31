import 'package:flutter/material.dart';

import 'package:jendela_dbp/components/authentication/password_form.dart';
import 'package:jendela_dbp/view/authentication/popup_password.dart';

class CreateNewPassword extends StatelessWidget {
  const CreateNewPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: SizedBox(
                  height: 170,
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Text(
                    'Create New Password',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Your new password has to be different',
                    style: TextStyle(
                      color: Color.fromARGB(255, 123, 123, 123),
                    ),
                  ),
                  Text(
                    'from previously used password',
                    style: TextStyle(
                      color: Color.fromARGB(255, 123, 123, 123),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            AuthPasswordForm(
              fieldName: 'Password',
            ),
            AuthPasswordForm(
              fieldName: 'Confirm Password',
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 100),
              child: SizedBox(
                width: 100,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(
                      color: Color.fromARGB(255, 235, 127, 35),
                    ),
                    backgroundColor: const Color.fromARGB(255, 235, 127, 35),
                    minimumSize: const Size.fromHeight(70),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          content: SizedBox(
                            height: 500,
                            width: 400,
                            child: PopupPassword(),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Create Password',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
