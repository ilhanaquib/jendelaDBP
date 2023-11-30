import 'package:flutter/material.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';

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
              'Set semula kata laluan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const Text(
              'Berjaya!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(
              height: 20,
            ),
             Text(
              'Kata laluan anda telah',
              style: TextStyle(
                  color: DbpColor().jendelaGray, fontSize: 15),
            ),
             Text(
              'berjaya ditukar',
              style: TextStyle(
                  color: DbpColor().jendelaGray, fontSize: 15),
            ),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side:  BorderSide(
                    color: DbpColor().jendelaOrange,
                  ),
                  backgroundColor: DbpColor().jendelaOrange,
                  minimumSize: const Size.fromHeight(50)),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signin');
              },
              child: const Text(
                'Log Masuk',
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
