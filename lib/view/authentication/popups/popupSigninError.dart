import 'package:flutter/material.dart';

class PopupSigninError extends StatelessWidget {
  PopupSigninError({super.key, required this.errorMessage});

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
                  height: 190,
                  child: Image.asset('assets/images/popupError.png')),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Sign In Failed',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Failed to sign in your account',
              style: TextStyle(
                  color: Color.fromARGB(255, 123, 123, 123), fontSize: 15),
            ),
            const Text(
              'please try again',
              style: TextStyle(
                  color: Color.fromARGB(255, 123, 123, 123), fontSize: 15),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Error : $errorMessage',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color.fromARGB(255, 123, 123, 123), fontSize: 15),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(
                    color: Color.fromARGB(255, 235, 127, 35),
                  ),
                  backgroundColor: const Color.fromARGB(255, 235, 127, 35),
                  
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Dismiss',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
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
