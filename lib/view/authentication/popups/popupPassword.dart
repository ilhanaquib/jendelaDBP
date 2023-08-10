import 'package:flutter/material.dart';

class PopupPassword extends StatelessWidget {
  const PopupPassword({super.key});

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
                  height: 190, child: Image.asset('assets/images/popup2.png')),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Reset Password',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const Text(
              'Successful!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Your new password has been',
              style: TextStyle(
                  color: Color.fromARGB(255, 123, 123, 123), fontSize: 15),
            ),
            const Text(
              'successfully changed',
              style: TextStyle(
                  color: Color.fromARGB(255, 123, 123, 123), fontSize: 15),
            ),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(
                    color: Color.fromARGB(255, 235, 127, 35),
                  ),
                  backgroundColor: const Color.fromARGB(255, 235, 127, 35),
                  minimumSize: const Size.fromHeight(50)),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signin');
              },
              child: const Text(
                'Sign In',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
