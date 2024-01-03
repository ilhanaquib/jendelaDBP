import 'package:flutter/material.dart';
import 'package:jendela_dbp/stateManagement/cubits/auth_cubit.dart';
import 'package:jendela_dbp/view/authentication/signin.dart';
import 'package:jendela_dbp/view/pages/profile/profile_screen.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:jendela_dbp/view/authentication/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({
    super.key,
  });

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  AuthCubit authCubit = AuthCubit();
  late String _username = '';
  DateTime currentTime = DateTime.now();
  String _getGreeting(int hour) {
    if (hour > 5 && hour < 12) {
      return 'Selamat Pagi';
    } else if (hour < 13) {
      return 'Selamat Tengah Hari';
    } else if (hour < 19) {
      return 'Selamat Petang';
    } else {
      return 'Selamat Malam';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUsername(); 
  }

  Future<void> _fetchUsername() async {
    bool isLoggedIn = await authCubit.getUserLoginOrNot();
    if (isLoggedIn) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _username = prefs.getString('currentUser') ??
          '';
      setState(() {}); 
    }
  }

  @override
  Widget build(BuildContext context) {
    String greeting = _getGreeting(currentTime.hour);

    return Drawer(
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)),
      child: FutureBuilder<bool>(
        future:
            authCubit.getUserLoginOrNot(), // Check login status asynchronously
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(); // Show loading indicator while checking login status
          } else {
            if (snapshot.hasData) {
              final bool isLoggedIn = snapshot.data!;
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    child: isLoggedIn
                        ? Text(
                            '$greeting, $_username') // Display username when logged in
                        : const Text('Menu'),
                  ),
                  if (isLoggedIn)
                    _buildDrawerItem('Akaun', () {
                      _handleAkaunTap(context);
                    }),
                  if (!isLoggedIn)
                    _buildDrawerItem('Log Masuk', () {
                      _handleLogMasukTap(context);
                    }),
                  if (!isLoggedIn)
                    _buildDrawerItem('Daftar Akaun', () {
                      _handleDaftarAkaunTap(context);
                    }),
                ],
              );
            } else {
              return const Text('Error retrieving login status');
            }
          }
        },
      ),
    );
  }

  Widget _buildDrawerItem(String title, Function() onTap) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }

  void _handleAkaunTap(BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
      screen: const ProfileScreen(),
    );
  }

  void _handleLogMasukTap(BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
      screen: const Signin(),
    );
  }

  void _handleDaftarAkaunTap(BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
      screen: const Signup(),
    );
  }
}
