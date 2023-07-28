import 'package:flutter/material.dart';
import 'package:jendela_dbp/components/authentication/auth_provider.dart';
import 'package:jendela_dbp/components/authentication/form.dart';
import 'package:jendela_dbp/components/authentication/auth_checkbox.dart';
import 'package:jendela_dbp/components/authentication/password_form.dart';

class Signin extends StatelessWidget {
  const Signin({super.key});

  @override
  Widget build(BuildContext context) {
    void goToSignup() {
      Navigator.pushReplacementNamed(context, '/signup');
    }

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
                    'Welcome Back',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'We are happy to see you here again.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 123, 123, 123),
                    ),
                  ),
                  Text(
                    'Enter your email and password',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 123, 123, 123),
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
            AuthPasswordForm(
              fieldName: 'Password',
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    children: [
                      AuthCheckbox(),
                      Text(
                        'Remember me',
                        style: TextStyle(
                            color: Color.fromARGB(255, 123, 123, 123),
                            fontSize: 13,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgotPassword');
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: Color.fromARGB(255, 123, 123, 123),
                          fontSize: 13,
                          fontWeight: FontWeight.normal),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 20),
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
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            AuthProvider(
              account: 'Don\'t have an account? ',
              orangeAccount: ' Sign Up',
              pageNavigator: goToSignup,
            )
          ],
        ),
      ),
    );
  }
}
