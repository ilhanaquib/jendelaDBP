import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jendela_dbp/components/authentication/authProvider.dart';
import 'package:jendela_dbp/components/authentication/authCheckbox.dart';
import 'package:jendela_dbp/stateManagement/cubits/AuthCubit.dart';
import 'package:jendela_dbp/stateManagement/states/authState.dart';
import 'package:jendela_dbp/view/authentication/popups/popupSigninError.dart';
import 'package:jendela_dbp/main.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
    void goToSignup() {
      Navigator.pushReplacementNamed(context, '/signup');
    }

    void navigateToHome(BuildContext context) {
      // This function will navigate to the '/home' route using popUntil

      // Create a predicate to check if a route's name is '/home'
      isHomeRoute(route) => route.settings.name == '/home';

      // Pop routes until the desired route is reached (if it exists)
      Navigator.popUntil(context, isHomeRoute);

      // Push the '/home' route onto the stack
      Navigator.pushNamed(context, '/home');
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
                    'Welcome Back',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'We are happy to see you here again.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 123, 123, 123),
                    ),
                  ),
                  Text(
                    'Enter your email and password',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 123, 123, 123),
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
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
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
                        labelText: 'Email Or Username',
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
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    children: [
                      AuthCheckbox(),
                      Text(
                        'Remember me',
                        style: TextStyle(
                            color: Color.fromARGB(255, 123, 123, 123),
                            fontSize: 13,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgotPassword');
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: Color.fromARGB(255, 123, 123, 123),
                          fontSize: 13,
                          fontWeight: FontWeight.normal),
                    ),
                  )
                ],
              ),
            ),
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
                        final authCubit = BlocProvider.of<AuthCubit>(context);
                        final email = emailController.text;
                        final password = passwordController.text;

                        authCubit.login(
                          context,
                          isToLogin: true,
                          formKey: _formKey,
                          usernameController: TextEditingController(
                              text: email), // Pass email or username here
                          passwordController:
                              TextEditingController(text: password),
                        );
                      },
                      child: const Text(
                        'Sign In',
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
                    showHomeNotifier.value = true;
                    Navigator.pushNamed(context, '/home');
                  } else if (state is AuthError) {
                    _showErrorPopup(state.message ?? 'An error occurred');
                  }
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            AuthProvider(
              account: 'Don\'t have an account? ',
              orangeAccount: ' Sign Up',
              guest: 'You can also continue as',
              guestAccount: ' Guest',
              pageNavigator: goToSignup,
            )
          ],
        ),
      ),
    );
  }
}
