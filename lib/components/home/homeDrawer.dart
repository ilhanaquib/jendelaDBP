import 'package:flutter/material.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:jendela_dbp/view/authentication/signin.dart';
import 'package:jendela_dbp/view/authentication/signup.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text('Username'),
            ),
            ListTile(
              title: const Text('Sign In'),
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(context,
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    screen: const Signin());
              },
            ),
            ListTile(
              title: const Text('Sign Up'),
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(context,
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    screen: const Signup());
              },
            )
          ],
        ),
      );
  }
}