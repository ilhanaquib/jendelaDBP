import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:jendela_dbp/components/authentication/form.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

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
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  const Text(
                    'Forgot Password',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'No worries, we\'ll send you reset instructions. ',
                    style: TextStyle(
                      color: DbpColor().jendelaGray,
                    ),
                  ),
                  Text(
                    'Enter your email to reset password',
                    style: TextStyle(
                      color: DbpColor().jendelaGray,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            AuthForm(
              fieldName: 'Email',
              fieldIcon: Icons.alternate_email_rounded,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 270),
              child: SizedBox(
                width: 100,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: DbpColor().jendelaOrange,
                      ),
                      backgroundColor: DbpColor().jendelaOrange,
                      minimumSize: const Size.fromHeight(70)),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, '/verificationPassword');
                  },
                  child: const Text(
                    'Send',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Back to ',
                      style: TextStyle(
                          color: DbpColor().jendelaGray,
                          fontSize: 17,
                          fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacementNamed(context, '/signin');
                        },
                      text: 'Sign In',
                      style: TextStyle(
                          color: DbpColor().jendelaOrange,
                          fontSize: 17,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
