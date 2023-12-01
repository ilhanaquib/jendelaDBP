import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jendela_dbp/components/authentication/auth_provider.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/controllers/screen_size.dart';
import 'package:jendela_dbp/stateManagement/cubits/auth_cubit.dart';
import 'package:jendela_dbp/stateManagement/states/auth_state.dart';
import 'package:jendela_dbp/view/authentication/popups/popup_signup.dart';
import 'package:jendela_dbp/view/authentication/popups/popup_signup_error.dart';
import 'package:jendela_dbp/view/authentication/popups/popup_terms.dart';
import 'package:msh_checkbox/msh_checkbox.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isToLogin = false;
  bool shouldCheck = false;
  bool enableButton = false;

  @override
  void initState() {
    super.initState();
  }

  void _showSuccessPopup() {
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
            child: PopupSignupError(errorMessage: errorMessage),
          ),
        );
      },
    );
  }

  void _showTerms() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 500,
            width: 400,
            child: PopupTerms(),
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

    void goToSignin() {
      Navigator.pushReplacementNamed(context, '/signin');
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
              padding: const EdgeInsets.only(),
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
                    'Mari kita mulakan',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Cipta akaun baru anda',
                    style: TextStyle(
                      fontSize: 15,
                      color: DbpColor().jendelaGray,
                    ),
                  ),
                  Text(
                    'Ia hanya mengambil masa yang singkat',
                    style: TextStyle(
                      fontSize: 15,
                      color: DbpColor().jendelaGray,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // form

            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // username
                  Padding(
                    padding: padding,
                    child: TextFormField(
                      controller: usernameController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Sila masukkan nama pengguna";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        suffixIcon: const Icon(
                          Icons.person_rounded,
                          color: Color.fromARGB(255, 162, 162, 162),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 185, 185, 185),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        labelText: 'Nama Pengguna',
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

                  // email
                  Padding(
                    padding: padding,
                    child: TextFormField(
                      controller: emailController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Sila masukkan emel anda";
                        } else if (!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                            .hasMatch(value)) {
                          return "Please enter a valid email";
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
                        labelText: 'Emel',
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
                          return "Sila masukkan kata laluan anda";
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
                            //print(_passwordVisible);
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

                  // confirm password
                  Padding(
                    padding: padding,
                    child: TextFormField(
                      controller: confirmPasswordController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Sila ulangi kata laluan anda";
                        } else {
                          return null;
                        }
                      },
                      obscureText: !_confirmPasswordVisible,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _confirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color.fromARGB(255, 162, 162, 162),
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 185, 185, 185),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        labelText: 'Sahkan Kata Laluan',
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

            Padding(
              padding: padding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: MSHCheckbox(
                          value: shouldCheck,
                          style: MSHCheckboxStyle.fillScaleCheck,
                          size: 20,
                          // ignore: deprecated_member_use
                          checkedColor: DbpColor().jendelaOrange,
                          // ignore: deprecated_member_use
                          uncheckedColor: DbpColor().jendelaOrange,
                          onChanged: (val) {
                            setState(() {
                              shouldCheck = val;
                              enableButton = !enableButton;
                            });
                          },
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Saya setuju dengan',
                              style: TextStyle(
                                  color: DbpColor().jendelaGray,
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _showTerms();
                                },
                              text: ' Terma & Syarat',
                              style: TextStyle(
                                  color: DbpColor().jendelaOrange,
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // create account button
            Padding(
              padding: padding,
              child: BlocConsumer<AuthCubit, AuthState>(
                // Use BlocConsumer to interact with the AuthCubit
                builder: (context, state) {
                  return SizedBox(
                    width: 100,
                    height: 50,
                    child: OutlinedButton(
                      style: enableButton
                          ? OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: DbpColor().jendelaOrange,
                              ),
                              backgroundColor: DbpColor().jendelaOrange,
                              minimumSize: const Size.fromHeight(70),
                            )
                          : OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: DbpColor().jendelaGray,
                              ),
                              backgroundColor: DbpColor().jendelaGray,
                              minimumSize: const Size.fromHeight(70)),
                      onPressed: enableButton
                          ? () {
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
                                // Check if the state is AuthLoading before proceeding
                                if (state is AuthLoading) {
                                  return;
                                }

                                // Call the signup function from the AuthCubit
                                context.read<AuthCubit>().signup(
                                      usernameController.text,
                                      emailController.text,
                                      passwordController.text,
                                      confirmPasswordController.text,
                                    );
                              }
                            }
                          : () {
                              null;
                            },
                      child: const Text(
                        'Cipta Akaun',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
                listener: (context, state) {
                  // Handle state changes if needed
                  if (state is AuthLoaded) {
                    _showSuccessPopup();
                  } else if (state is AuthError) {
                    _showErrorPopup(state.message ?? 'Ralat Berlaku');
                  }
                },
              ),
            ),
            AuthProvider(
              account: 'Sudah mempunyai akaun?',
              orangeAccount: ' Log Masuk',
              guest: 'Anda juga boleh teruskan sebagai',
              guestAccount: ' Tetamu',
              pageNavigator: goToSignin,
            )
          ],
        ),
      ),
    );
  }
}
