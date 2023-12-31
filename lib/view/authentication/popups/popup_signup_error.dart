import 'package:flutter/material.dart';

import 'package:jendela_dbp/controllers/dbp_color.dart';

// ignore: must_be_immutable
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
                  height: 190,
                  child: Image.asset('assets/images/popupError.png')),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Daftar Akaun Gagal',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(
              height: 40,
            ),
             Text(
              'Akaun anda gagal untuk dicipta',
              style: TextStyle(
                  color: DbpColor().jendelaGray, fontSize: 15),
            ),
             Text(
              'sila cuba sekali lagi',
              style: TextStyle(
                  color: DbpColor().jendelaGray, fontSize: 15),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Ralat : $errorMessage',
              textAlign: TextAlign.center,
              style:  TextStyle(
                  color: DbpColor().jendelaGray, fontSize: 15),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side:  BorderSide(
                    color: DbpColor().jendelaOrange,
                  ),
                  backgroundColor: DbpColor().jendelaOrange,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Baik',
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
