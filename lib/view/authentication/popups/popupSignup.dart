import 'package:flutter/material.dart';

class PopupSignup extends StatelessWidget {
  const PopupSignup({super.key});

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
                  height: 190, child: Image.asset('assets/images/popup1.png')),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Sign Up Successful!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Your account has been created.',
              style: TextStyle(
                  color: Color.fromARGB(255, 123, 123, 123), fontSize: 15),
            ),
            const Text(
              'Please wait a moment, we are',
              style: TextStyle(
                  color: Color.fromARGB(255, 123, 123, 123), fontSize: 15),
            ),
            const Text(
              'preparing for you',
              style: TextStyle(
                  color: Color.fromARGB(255, 123, 123, 123), fontSize: 15),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(
                  color: Color.fromARGB(255, 235, 127, 35),
                ),
                backgroundColor: const Color.fromARGB(255, 235, 127, 35),
                minimumSize: const Size.fromHeight(70),
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
          ],
        ),
      ),
    );
  }
}
