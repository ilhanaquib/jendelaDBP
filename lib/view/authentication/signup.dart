import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jendela_dbp/components/authentication/authProvider.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';
import 'package:jendela_dbp/controllers/screenSize.dart';
import 'package:jendela_dbp/stateManagement/cubits/AuthCubit.dart';
import 'package:jendela_dbp/stateManagement/states/authState.dart';
import 'package:jendela_dbp/view/authentication/popups/popupSignup.dart';
import 'package:jendela_dbp/view/authentication/popups/popupSignupError.dart';
import 'package:jendela_dbp/view/authentication/popups/popupTerms.dart';
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
        return AlertDialog(
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
                    'Let\'s Get Started',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Create your account,',
                    style: TextStyle(
                      fontSize: 15,
                      color: DbpColor().jendelaGray,
                    ),
                  ),
                  Text(
                    'it takes less than a minute',
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
                          return "Please enter a username";
                        } else
                          return null;
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
                        labelText: 'Username',
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
                          return "Please enter an email";
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
                        labelText: 'Email',
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
                          return "Please enter a password";
                        } else
                          return null;
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
                            print(_passwordVisible);
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
                        labelText: 'Password',
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
                          return "Please repeat your password";
                        } else
                          return null;
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
                        labelText: 'Confirm Password',
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
                          checkedColor: DbpColor().jendelaOrange,
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
                              text: 'I agree to the',
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
                              text: ' Terms & Conditions',
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
                        'Create Account',
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
                    _showErrorPopup(state.message ?? 'An error occured');
                  }
                },
              ),
            ),
            AuthProvider(
              account: 'Already have an account?',
              orangeAccount: ' Sign In',
              guest: 'You can also continue as',
              guestAccount: ' Guest',
              pageNavigator: goToSignin,
            )
          ],
        ),
      ),
    );
  }
}
