import 'package:flutter/material.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';

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
             Text(
              'Your account has been created.',
              style: TextStyle(
                  color: DbpColor().jendelaGray, fontSize: 15),
            ),
             Text(
              'Please wait a moment, we are',
              style: TextStyle(
                  color: DbpColor().jendelaGray, fontSize: 15),
            ),
             Text(
              'preparing for you',
              style: TextStyle(
                  color: DbpColor().jendelaGray, fontSize: 15),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side:  BorderSide(
                  color: DbpColor().jendelaOrange,
                ),
                backgroundColor: DbpColor().jendelaOrange,
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
