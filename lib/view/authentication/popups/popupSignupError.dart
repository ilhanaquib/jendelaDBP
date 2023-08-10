import 'package:flutter/material.dart';

class PopupSignupError extends StatelessWidget {
  PopupSignupError({super.key, required this.errorMessage});

  String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SizedBox(
                  height: 190, child: Image.asset('assets/images/popupError.png')),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Sign Up Failed',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Your account failed to be created.',
              style: TextStyle(
                  color: Color.fromARGB(255, 123, 123, 123), fontSize: 15),
            ),
            const Text(
              'please try again',
              style: TextStyle(
                  color: Color.fromARGB(255, 123, 123, 123), fontSize: 15),
            ),
            Text(
              'Error : $errorMessage',
              style: const TextStyle(
                  color: Color.fromARGB(255, 123, 123, 123), fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
