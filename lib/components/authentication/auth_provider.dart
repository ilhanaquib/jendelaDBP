import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class AuthProvider extends StatelessWidget {
  AuthProvider({super.key, required this.account, required this.orangeAccount, required this.pageNavigator});

  String account;
  String orangeAccount;

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
                    ))),
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
          height: 40,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: account,
                style: const TextStyle(
                    color: Color.fromARGB(255, 123, 123, 123),
                    fontSize: 17,
                    fontWeight: FontWeight.normal),
              ),
              TextSpan(
                recognizer: TapGestureRecognizer()..onTap = pageNavigator,
                text: orangeAccount,
                style: const TextStyle(
                    color: Color.fromARGB(255, 235, 127, 35),
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
