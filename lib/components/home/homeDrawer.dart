import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/stateManagement/blocs/imagePickerBloc.dart';
import 'package:jendela_dbp/view/pages/userIcon.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:jendela_dbp/view/authentication/signin.dart';
import 'package:jendela_dbp/view/authentication/signup.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key, required this.updateAppBar});

  final VoidCallback updateAppBar;

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
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
            title: const Text('Avatar'),
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                withNavBar: false,
                screen: BlocProvider.value(
                  value: context.read<ImageBloc>(),
                  child: UserHomeScreen(
                    updateAppBar: widget.updateAppBar,
                  ),
                ),
              );
            },
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
