import 'package:flutter/material.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';

class PopupTerms extends StatelessWidget {
  PopupTerms({
    super.key,
  });

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
                child: Image.asset('assets/images/popupError.png'),
              ),
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
             Text(
              'Failed to sign in your account',
              style: TextStyle(
                  color: DbpColor().jendelaGray, fontSize: 15),
            ),
             Text(
              'please try again',
              style: TextStyle(
                  color: DbpColor().jendelaGray, fontSize: 15),
            ),
            const SizedBox(
              height: 20,
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
