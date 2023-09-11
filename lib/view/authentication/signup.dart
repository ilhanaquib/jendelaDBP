import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jendela_dbp/components/authentication/authProvider.dart';
import 'package:jendela_dbp/stateManagement/cubits/AuthCubit.dart';
import 'package:jendela_dbp/stateManagement/states/authState.dart';
import 'package:jendela_dbp/view/authentication/popups/popupSignup.dart';
import 'package:jendela_dbp/view/authentication/popups/popupSignupError.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
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
                  height: 170,
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Text(
                    'Let\'s Get Started',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Create your account,',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 123, 123, 123),
                    ),
                  ),
                  Text(
                    'it takes less than a minute',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 123, 123, 123),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // form

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // username
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    controller: usernameController,
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
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 123, 123, 123),
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
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: TextFormField(
                    controller: emailController,
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
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 123, 123, 123),
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
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: TextFormField(
                    controller: passwordController,
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
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 123, 123, 123),
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
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: TextFormField(
                    controller: confirmPasswordController,
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
                            _confirmPasswordVisible = !_confirmPasswordVisible;
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
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 123, 123, 123),
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

            // checkbox
            // Padding(
            //   padding: const EdgeInsets.only(left: 7),
            //   child: Row(
            //     children: [
            //       const AuthCheckbox(),
            //       RichText(
            //         text: TextSpan(
            //           children: [
            //             const TextSpan(
            //               text: 'I agree to the',
            //               style: TextStyle(
            //                   color: Color.fromARGB(255, 123, 123, 123),
            //                   fontSize: 17,
            //                   fontWeight: FontWeight.normal),
            //             ),
            //             TextSpan(
            //               recognizer: TapGestureRecognizer()..onTap = () {},
            //               text: ' Terms & Conditions',
            //               style: const TextStyle(
            //                   color: Color.fromARGB(255, 235, 127, 35),
            //                   fontSize: 17,
            //                   fontWeight: FontWeight.normal),
            //             )
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // create account button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: BlocConsumer<AuthCubit, AuthState>(
                // Use BlocConsumer to interact with the AuthCubit
                builder: (context, state) {
                  return SizedBox(
                    width: 100,
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                          color: Color.fromARGB(255, 235, 127, 35),
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 235, 127, 35),
                        minimumSize: const Size.fromHeight(70),
                      ),
                      onPressed: () {
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
                    _showErrorPopup(state.message ?? 'An error occurred');
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
