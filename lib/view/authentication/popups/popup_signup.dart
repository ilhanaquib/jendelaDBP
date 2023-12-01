import 'package:flutter/material.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';

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
              'Daftar Akaun Berjaya!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(
              height: 40,
            ),
             Text(
              'Akaun anda telah dicipta',
              style: TextStyle(
                  color: DbpColor().jendelaGray, fontSize: 15),
            ),
             Text(
              'Sila tunggu sebentar, kami sedang',
              style: TextStyle(
                  color: DbpColor().jendelaGray, fontSize: 15),
            ),
             Text(
              'menyediakan akaun untuk anda',
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
                'Baik',
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
