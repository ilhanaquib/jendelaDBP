import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/components/authentication/auth_provider.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/controllers/screen_size.dart';
import 'package:jendela_dbp/stateManagement/cubits/auth_cubit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _LoginCard createState() => _LoginCard();
}

class _LoginCard extends State<LoginCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _autoValidate = AutovalidateMode.disabled;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // Box<BookAPI> bookAPIBox = Hive.box<BookAPI>(topBookBox);
  bool _passwordVisible = false;

  dynamic passwordCred;
  bool getKategori1Status = false;
  bool getKategori2Status = false;
  bool getKategori3Status = false;
  bool getKategori4Status = false;
  bool testInternetAccess = false;

  bool isLoading = false;
  bool isToLogin = false;
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences? prefs;
  DbpColor colors = DbpColor();
  void goToSignup() {
    Navigator.pushReplacementNamed(context, '/signup');
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.landscapeRight,
      // DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    setState(() {
      usernameController.text = "";
      passwordController.text = "";
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<void> checkUserLoginData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   // Check if user data exists in SharedPreferences
  //   String? currentUser = prefs.getString('currentUser');
  //   String? token = prefs.getString('token');
  //   int? userId = prefs.getInt('id');

  //   // Check if the necessary data exists to determine user login status
  //   if (currentUser != null &&
  //       currentUser.isNotEmpty &&
  //       token != null &&
  //       userId != null) {
  //     // User is logged in
  //     print('User is logged in');
  //     print('Current user: $currentUser');
  //     print('User token: $token');
  //     print('User ID: $userId');
  //   } else {
  //     // User is not logged in or missing some required data
  //     print('User is not logged in');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    EdgeInsetsGeometry padding;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      padding = const EdgeInsets.only(left: 600, right: 600, top: 20);
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      padding = const EdgeInsets.only(left: 150, right: 150, top: 20);
    } else {
      // Use the default padding for phones and other devices
      padding = const EdgeInsets.only(left: 15, right: 15, top: 20);
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 150.0),
          child: Form(
            autovalidateMode: _autoValidate,
            key: _formKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Anda belum log masuk',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                Text(
                  'Sila log masuk untuk lihat buku yang telah dibeli',
                  style: TextStyle(
                    fontSize: 15,
                    color: DbpColor().jendelaGray,
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: TextFormField(
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Sila masukkan nama pengguna";
                            } else {
                              return null;
                            }
                          },
                          controller: usernameController,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            suffixIcon: const Icon(
                              Icons.email_rounded,
                              color: Color.fromARGB(255, 162, 162, 162),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 185, 185, 185),
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            labelText: 'Emel atau nama pengguna',
                            labelStyle: TextStyle(
                              color: DbpColor().jendelaGray,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 185, 185, 185),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 185, 185, 185),
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: TextFormField(
                          // key: widget.fieldKey,
                          validator: (String? value) {
                            if (passwordController.text.isEmpty) {
                              return 'Kata laluan diperlukan';
                            }
                            return null;
                          },
                          obscureText: !_passwordVisible,
                          cursorColor: Colors.red,
                          controller: passwordController,
                          // onFieldSubmitted: widget.onFieldSubmitted,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color.fromARGB(255, 162, 162, 162),
                              ),
                              onPressed: () {
                                // print(_passwordVisible);
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 185, 185, 185),
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            labelText: 'Kata Laluan',
                            labelStyle: TextStyle(
                              color: DbpColor().jendelaGray,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 185, 185, 185),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 185, 185, 185),
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                        )),
                    testInternetAccess
                        ? LoadingAnimationWidget.discreteCircle(
                            color: DbpColor().jendelaGray,
                            secondRingColor: DbpColor().jendelaGreen,
                            thirdRingColor: DbpColor().jendelaOrange,
                            size: 50.0,
                          )
                        : isToLogin
                            ? LoadingAnimationWidget.discreteCircle(
                                color: DbpColor().jendelaGray,
                                secondRingColor: DbpColor().jendelaGreen,
                                thirdRingColor: DbpColor().jendelaOrange,
                                size: 50.0,
                              )
                            : SizedBox(
                                height: 70,
                                width: 500,
                                child: Padding(
                                  padding: padding,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: BorderSide(
                                        color: DbpColor().jendelaOrange,
                                      ),
                                      backgroundColor: DbpColor().jendelaOrange,
                                      minimumSize: const Size.fromHeight(70),
                                    ),
                                    onPressed: () async {
                                      isLoading = true;
                                      //   var connectivityResult =
                                      //       await (Connectivity()
                                      //           .checkConnectivity());
                                      //   if (connectivityResult ==
                                      //           ConnectivityResult.mobile ||
                                      //       connectivityResult ==
                                      //           ConnectivityResult.wifi) {
                                      //     _login();
                                      //   } else {
                                      //     ScaffoldMessenger.of(context)
                                      //         .showSnackBar(SnackBar(
                                      //       behavior: SnackBarBehavior.floating,
                                      //       content:
                                      //           Text('Tiada Sambungan Internet'),
                                      //       duration: Duration(seconds: 3),
                                      //     ));
                                      //   }
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);
                                      currentFocus.unfocus();
                                      setState(() {
                                        testInternetAccess = true;
                                      });
                                      try {
                                        final result =
                                            await InternetAddress.lookup(
                                                    'google.com')
                                                .timeout(
                                                    const Duration(seconds: 3));
                                        if (result.isNotEmpty &&
                                            result[0].rawAddress.isNotEmpty) {
                                          setState(() {
                                            testInternetAccess = false;
                                          });
                                          Map authResult =
                                              await authCubit.login(context,
                                                  isToLogin: isToLogin,
                                                  formKey: _formKey,
                                                  usernameController:
                                                      usernameController,
                                                  passwordController:
                                                      passwordController);
                                          setState(() {
                                            isToLogin = authResult['isToLogin'];
                                            usernameController = authResult[
                                                'usernameController'];
                                            passwordController = authResult[
                                                'passwordController'];
                                          });
                                          if (isToLogin) {
                                            Future.delayed(
                                                    const Duration(seconds: 1))
                                                .then((value) async {
                                              // Navigator.of(context)
                                              //     .pushReplacementNamed('/Home');
                                              try {
                                                // pushNewScreen(
                                                //   context,
                                                //   screen: MyApp(),
                                                //   withNavBar:
                                                //       false, // OPTIONAL VALUE. True by default.
                                                // );
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                  '/home',
                                                );
                                              } catch (e, st) {
                                                await Sentry.captureException(
                                                  e,
                                                  stackTrace: st,
                                                );
                                              }
                                            });
                                          }
                                        }
                                      } catch (exception, stackTrace) {
                                        setState(() {
                                          testInternetAccess = false;
                                        });
                                        await Sentry.captureException(
                                          exception,
                                          stackTrace: stackTrace,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          content: Text('Tiada Akses Internet'),
                                          duration: Duration(seconds: 3),
                                        ));
                                      }
                                      setState(() {
                                        testInternetAccess = false;
                                      });
                                    },
                                    child: const Text(
                                      'Log Masuk',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: AuthProvider(
                        account: 'Tidak mempunyai akaun?',
                        orangeAccount: ' Daftar Akaun',
                        guest: 'Anda juga boleh teruskan sebagai',
                        guestAccount: ' Tetamu',
                        pageNavigator: goToSignup,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
