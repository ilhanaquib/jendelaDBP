import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jendela_dbp/components/authentication/auth_provider.dart';
import 'package:jendela_dbp/components/authentication/form.dart';
import 'package:jendela_dbp/components/authentication/auth_checkbox.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

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
                    'Let\'s Get Started',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Create your account,',
                    style: TextStyle(
                      color: Color.fromARGB(255, 123, 123, 123),
                    ),
                  ),
                  Text(
                    'it takes less than a minute',
                    style: TextStyle(
                      color: Color.fromARGB(255, 123, 123, 123),
                    ),
                  ),
                ],
              ),
            ),
            AuthForm(
              fieldName: 'Username',
              fieldIcon: Icons.person_rounded,
            ),
            AuthForm(
              fieldName: 'Email',
              fieldIcon: Icons.alternate_email_rounded,
            ),
            AuthForm(
              fieldName: 'Password',
              fieldIcon: Icons.visibility_off,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7),
              child: Row(
                children: [
                  const AuthCheckbox(),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'I agree to the',
                          style: TextStyle(
                              color: Color.fromARGB(255, 123, 123, 123),
                              fontSize: 17,
                              fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text: ' Terms & Conditions',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 235, 127, 35),
                              fontSize: 17,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                      minimumSize: const Size.fromHeight(70)),
                  onPressed: () async {},
                  child: const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            AuthProvider(account: 'Already have an account?', orangeAccount: 'Sign In',)
          ],
        ),
      ),
    );
  }
}
