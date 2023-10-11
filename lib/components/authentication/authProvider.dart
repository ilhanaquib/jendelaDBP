import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:jendela_dbp/components/persistentBottomNavBar.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';
import 'package:jendela_dbp/main.dart';

// ignore: must_be_immutable
class AuthProvider extends StatelessWidget {
  AuthProvider(
      {super.key,
      required this.account,
      required this.orangeAccount,
      required this.pageNavigator,
      required this.guest,
      required this.guestAccount});

  String account;
  String orangeAccount;
  String guest;
  String guestAccount;

  void Function() pageNavigator;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('or Connect with'),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.apple,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {},
                child: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    child: Center(
                        child: Icon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                      size: 20,
                    ))),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: account,
                style:  TextStyle(
                    color: DbpColor().jendelaGray,
                    fontSize: 17,
                    fontWeight: FontWeight.normal),
              ),
              TextSpan(
                recognizer: TapGestureRecognizer()..onTap = pageNavigator,
                text: orangeAccount,
                style:  TextStyle(
                    color: DbpColor().jendelaOrange,
                    fontSize: 17,
                    fontWeight: FontWeight.normal),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: guest,
                style:  TextStyle(
                    color: DbpColor().jendelaGray,
                    fontSize: 17,
                    fontWeight: FontWeight.normal),
              ),
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showHomeNotifier.value = true;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const MyPersistentBottomNavBar(),
                      ),
                      (route) =>
                          false, // Prevent going back to the previous page
                    );
                  },
                text: guestAccount,
                style:  TextStyle(
                    color: DbpColor().jendelaOrange,
                    fontSize: 17,
                    fontWeight: FontWeight.normal),
              )
            ],
          ),
        ),
      ],
    );
  }
}
