import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:jendela_dbp/api-services.dart';

import 'package:jendela_dbp/components/authentication/authProvider.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';
import 'package:jendela_dbp/controllers/getBooksFromApi.dart';
import 'package:jendela_dbp/controllers/globalVar.dart';
import 'package:jendela_dbp/controllers/screenSize.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:jendela_dbp/model/userModel.dart';
import 'package:jendela_dbp/view/authentication/popups/popupSigninError.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool shouldCheck = false;
  bool _passwordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isToLogin = false;
  bool isLoading = false;
  bool testInternetAccess = false;

  @override
  void initState() {
    super.initState();
  }

  void _showErrorPopup(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 500,
            width: 400,
            child: PopupSigninError(errorMessage: errorMessage),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      padding = const EdgeInsets.only(left: 600, right: 600, top: 20);
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      padding = const EdgeInsets.only(left: 150, right: 150, top: 20);
    } else {
      // Use the default padding for phones and other devices
      padding = const EdgeInsets.only(left: 20, right: 20, top: 20);
    }
    void goToSignup() {
      Navigator.pushReplacementNamed(context, '/signup');
    }

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
                  height: 120,
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  const Text(
                    'Selamat Kembali',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Kami gembira untuk bertemu kembali',
                    style: TextStyle(
                      fontSize: 15,
                      color: DbpColor().jendelaGray,
                    ),
                  ),
                  Text(
                    'Masukkan emel dan kata laluan anda',
                    style: TextStyle(
                      fontSize: 15,
                      color: DbpColor().jendelaGray,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),

            // form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // email or username
                  Padding(
                    padding: padding,
                    child: TextFormField(
                      controller: emailController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Sila masukkan emel atau nama pengguna";
                        }
                        return null;
                      },
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
                        labelText: 'Email atau Nama Pengguna',
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

                  // password
                  Padding(
                    padding: padding,
                    child: TextFormField(
                      controller: passwordController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Sila masukkan kata laluan";
                        } else {
                          return null;
                        }
                      },
                      obscureText: !_passwordVisible,
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
                    ),
                  ),
                ],
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.only(left: 0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Row(
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.only(right: 8),
            //             child: MSHCheckbox(
            //               value: shouldCheck,
            //               style: MSHCheckboxStyle.fillScaleCheck,
            //               size: 20,
            //               checkedColor: DbpColor().jendelaOrange,
            //               uncheckedColor: DbpColor().jendelaOrange,
            //               onChanged: (val) {
            //                 setState(() {
            //                   shouldCheck = val;
            //                 });
            //               },
            //             ),
            //           ),
            //           Text(
            //             'Remember me',
            //             style: TextStyle(
            //                 color: DbpColor().jendelaGray,
            //                 fontSize: 13,
            //                 fontWeight: FontWeight.normal),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(
            //         width: 100,
            //       ),
            //       TextButton(
            //         onPressed: () {
            //           Navigator.pushNamed(context, '/forgotPassword');
            //         },
            //         child: Text(
            //           'Forgot Password?',
            //           style: TextStyle(
            //               color: DbpColor().jendelaOrange,
            //               fontSize: 13,
            //               fontWeight: FontWeight.normal),
            //         ),
            //       )
            //     ],
            //   ),
            // ),

            Padding(
              padding: padding,
              child: SizedBox(
                width: 100,
                height: 50,
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
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    currentFocus.unfocus();
                    setState(() {
                      testInternetAccess = true;
                    });
                    try {
                      final result = await InternetAddress.lookup('google.com')
                          .timeout(const Duration(seconds: 3));
                      if (result.isNotEmpty &&
                          result[0].rawAddress.isNotEmpty) {
                        setState(() {
                          testInternetAccess = false;
                        });
                        _login();
                      }
                    } catch (exception, stackTrace) {
                      setState(() {
                        testInternetAccess = false;
                      });
                      await Sentry.captureException(
                        exception,
                        stackTrace: stackTrace,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('Tiada Akses Internet'),
                          duration: Duration(seconds: 3),
                        ),
                      );
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

              // listener: (context, state) {
              //   // Handle state changes if needed
              //   if (state is AuthLoaded) {
              //     showHomeNotifier.value = true;
              //     Navigator.pushNamed(context, '/home');
              //   } else if (state is AuthError) {
              //     _showErrorPopup(state.message ?? 'An error occurred');
              //   }
              // },
            ),
            const SizedBox(
              height: 40,
            ),
            AuthProvider(
              account: 'Tidak mempunyai akaun?',
              orangeAccount: ' Daftar Akaun',
              guest: 'Anda juga boleh teruskan sebagai',
              guestAccount: ' Tetamu',
              pageNavigator: goToSignup,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      isToLogin = true;
    });
    final form = _formKey.currentState;
    if (!form!.validate()) {
      // _autoValidate = AutovalidateMode.onUserInteraction;
      setState(() {
        isToLogin = false;
      });
    } else {
      form.save();

      var data = {}; // Map
      data["username"] = emailController.text;
      data["password"] = passwordController.text;

      // Map data = {"username": "shafiqyajid", "password": "123456"};

      Object body = json.encode(data);
      //'https://jendeladbp.my/wp-json/jwt-auth/v1/token'
      try {
        ApiService.logMasuk(body).then((response) async {
          final int statusCode = response.statusCode;

          if (response.statusCode == 401) {
            _showErrorPopup('An error occurred');
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     '/Logout', (Route<dynamic> route) => false);
          } else if (response.statusCode == 200) {
            var data;
            data = json.decode(response.body);
            // print("my token" + data['token']);
            Response userRes = await ApiService.maklumatPengguna(data['token']);
            if (userRes.statusCode != 200) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                width: 200,
                behavior: SnackBarBehavior.floating,
                content: Text('Session Expired. Please login again'),
                duration: Duration(seconds: 1),
              ));
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //     '/Logout', (Route<dynamic> route) => false);
            }
            var userRespBody = json.decode(userRes.body);
            User user = User.fromJson(userRespBody);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('currentUser', emailController.text);
            // prefs.setString('passwordUser', passwordController.text);
            prefs.setString('token', data['token']);
            prefs.setInt('id', user.id ?? 0);

            ApiService.maklumatPengguna(data['token']).then((response) async {
              var dataUSer;
              dataUSer = json.decode(response.body);
              prefs.setString('userID', dataUSer['id'].toString());
              prefs.setString('userData', json.encode(dataUSer));
            }).catchError((e) {
              // print(e);
            });
            isToLogin = false;

            Future.delayed(const Duration(seconds: 1)).then((value) {
              Navigator.of(context).pushReplacementNamed('/home');
            });
          }
        });
      } catch (exception, stackTrace) {
        isToLogin = false;
        await Sentry.captureException(
          exception,
          stackTrace: stackTrace,
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(exception.toString()),
          duration: const Duration(seconds: 3),
        ));
      }
    }
  }
}

// ilhanaquib03
// Ilhannkz1
