import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:jendela_dbp/view/authentication/popups/popup_signup.dart';

class Verification extends StatelessWidget {
  const Verification({super.key});

  @override
  Widget build(BuildContext context) {
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
             Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  const Text(
                    'Verification',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'We have sent a verification code to your email',
                    style: TextStyle(
                      fontSize: 15,
                      color: DbpColor().jendelaGray,
                    ),
                  ),
                  const Text(
                    'mytest@gmail.com',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 80),
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 50,
                  fieldWidth: 50,
                  activeFillColor: Colors.white,
                  selectedColor: DbpColor().jendelaOrange,
                  inactiveColor: DbpColor().jendelaGray,
                  activeColor: DbpColor().jendelaGreen,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 290),
              child: SizedBox(
                width: 100,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side:  BorderSide(
                      color: DbpColor().jendelaOrange,
                    ),
                    backgroundColor: DbpColor().jendelaOrange,
                    minimumSize: const Size.fromHeight(70),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          content: SizedBox(
                            height: 500,
                            width: 400,
                            child: PopupSignup(),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Verify Now',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                     TextSpan(
                      text: 'Didn\'t receive code?',
                      style: TextStyle(
                          color: DbpColor().jendelaGray,
                          fontSize: 17,
                          fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()..onTap = () {},
                      text: ' Resend',
                      style:  TextStyle(
                          color: DbpColor().jendelaOrange,
                          fontSize: 17,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
