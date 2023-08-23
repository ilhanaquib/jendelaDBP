import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:jendela_dbp/api-services.dart';
import 'package:jendela_dbp/controllers/getBooksFromApi.dart';
import 'package:jendela_dbp/controllers/globalVar.dart';
import 'package:jendela_dbp/controllers/sizeConfig.dart';
import 'package:jendela_dbp/model/userModel.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sentry/sentry.dart';
//import 'package:connectivity/connectivity.dart';

TextEditingController passwordController = TextEditingController();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _autoValidate = AutovalidateMode.disabled;
  TextEditingController usernameController = TextEditingController();

  // Box<BookAPI> bookAPIBox = Hive.box<BookAPI>(topBookBox);
  bool _obscureText = true;

  var passwordCred;
  bool getKategori1Status = false;
  bool getKategori2Status = false;
  bool getKategori3Status = false;
  bool getKategori4Status = false;
  bool TestInternetAccess = false;

  bool isLoading = false;
  bool isToLogin = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences? prefs;

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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('JendelaDBP',
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 2.1)),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 5,
                        width: 70,
                        decoration: BoxDecoration(
                            color: const Color(0xff3b6878),
                            borderRadius: BorderRadius.circular(50)),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Form(
                autovalidateMode: _autoValidate,
                key: _formKey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        child: const Text(
                      'Log Masuk',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 37,
                          color: Color(0xff4F4F4F)),
                    )),
                    const SizedBox(
                      height: 100,
                    ),
                    Column(
                      children: [
                        Container(
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
                            style: const TextStyle(color: Colors.black, fontSize: 18),
                            decoration: InputDecoration(
                                hoverColor: Colors.yellow,
                                icon: const Icon(Icons.people_alt_sharp,
                                    color: Colors.black),
                                hintText: 'Nama Pengguna',
                                hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.5))),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: TextFormField(
                              // key: widget.fieldKey,
                              validator: _validatePassword,
                              obscureText: _obscureText,
                              maxLength: 16,
                              controller: passwordController,
                              // onFieldSubmitted: widget.onFieldSubmitted,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.7)),
                                icon: const Icon(Icons.lock, color: Colors.black),
                                filled: false,
                                hintText: "Kata Laluan",
                                suffixIcon: GestureDetector(
                                  dragStartBehavior: DragStartBehavior.down,
                                  onTap: () {
                                    if (_obscureText) {
                                      setState(() {
                                        _obscureText = false;
                                      });
                                    } else {
                                      setState(() {
                                        _obscureText = true;
                                      });
                                    }
                                  },
                                  child: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 50,
                        ),
                        TestInternetAccess
                            ? LoadingAnimationWidget.discreteCircle(
                                color: const Color.fromARGB(255, 123, 123, 123),
                                secondRingColor:
                                    const Color.fromARGB(255, 144, 191, 63),
                                thirdRingColor:
                                    const Color.fromARGB(255, 235, 127, 35),
                                size: 50.0,
                              )
                            : InkWell(
                                highlightColor: Colors.yellow,
                                borderRadius: BorderRadius.circular(30),
                                onTap: () async {
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
                                    TestInternetAccess = true;
                                  });
                                  try {
                                    final result = await InternetAddress.lookup(
                                            'google.com')
                                        .timeout(const Duration(seconds: 3));
                                    if (result.isNotEmpty &&
                                        result[0].rawAddress.isNotEmpty) {
                                      setState(() {
                                        TestInternetAccess = false;
                                      });
                                      _login();
                                    }
                                  } catch (exception, stackTrace) {
                                    setState(() {
                                      TestInternetAccess = false;
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
                                    TestInternetAccess = false;
                                  });
                                },
                                child: isToLogin
                                    ? LoadingAnimationWidget.discreteCircle(
                                        color: const Color.fromARGB(
                                            255, 123, 123, 123),
                                        secondRingColor: const Color.fromARGB(
                                            255, 144, 191, 63),
                                        thirdRingColor: const Color.fromARGB(
                                            255, 235, 127, 35),
                                        size: 50.0,
                                      )
                                    : Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        width: 350,
                                        decoration: BoxDecoration(
                                            color: const Color(0xff3b6878),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  blurRadius: 4,
                                                  spreadRadius: 0.5,
                                                  offset: const Offset(0, 3))
                                            ]),
                                        child: Text(
                                          'Log Masuk',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      2.5),
                                        ),
                                      ),
                              ),
                        // Padding(
                        //   padding:
                        //       const EdgeInsets.fromLTRB(0, 25, 0, 10),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Text(
                        //         'Bukan Ahli?',
                        //         style: TextStyle(color: Colors.black),
                        //       ),
                        //       SizedBox(
                        //         width: 5,
                        //       ),
                        //       InkWell(
                        //         onTap: () async {
                        //           var deviceID;
                        //           prefs = await SharedPreferences
                        //               .getInstance();
                        //           // deviceID = prefs.getString('DeviceID');
                        //           prefs.setString('DeviceID', null);
                        //           Navigator.of(context).pushNamed(
                        //             '/WelcomePage',
                        //           );
                        //         },
                        //         child: Text(
                        //           'Daftar Akaun',
                        //           style: TextStyle(
                        //               fontWeight: FontWeight.bold),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // InkWell(
                        //     onTap: () {
                        //       Navigator.of(context)
                        //           .pushReplacementNamed('/Home');
                        //     },
                        //     child: Text("bypass japp"))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // return OfflineBuilder(
    //   connectivityBuilder: (
    //     BuildContext context,
    //     ConnectivityResult connectivity,
    //     Widget child,
    //   ) {
    //     if (connectivity == ConnectivityResult.none) {
    //       return Material(
    //         child: NoInternetException(context),
    //       );
    //     } else {
    //       return child;
    //     }
    //   },
    //   builder: (BuildContext context) {

    //     return GestureDetector(
    //       onTap: () {
    //         FocusScopeNode currentFocus = FocusScope.of(context);
    //         if (!currentFocus.hasPrimaryFocus) {
    //           currentFocus.unfocus();
    //         }
    //       },
    //       child: Scaffold(
    //         key: _scaffoldKey,
    //         resizeToAvoidBottomInset: false,
    //         backgroundColor: Colors.white,
    //         appBar: AppBar(
    //           backgroundColor: Colors.white,
    //           elevation: 0,
    //         ),
    //         body: Padding(
    //           padding: const EdgeInsets.only(right: 20, left: 20),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 children: [
    //                   Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text('JendelaDBP', style: TextStyle(fontSize:  SizeConfig.textMultiplier *
    //                        2.1)),
    //                       SizedBox(
    //                         height: 20,
    //                       ),
    //                       Container(
    //                         height: 5,
    //                         width: 70,
    //                         decoration: BoxDecoration(
    //                             color: Color(0xff3b6878),
    //                             borderRadius: BorderRadius.circular(50)),
    //                       )
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //               SizedBox(
    //                 height: 50,
    //               ),
    //               Form(
    //                 autovalidateMode: _autoValidate,
    //                 key: _formKey,
    //                 child: Expanded(
    //                   child: Column(
    //                     // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Container(
    //                           child: Text(
    //                         'Log Masuk',
    //                         style: TextStyle(
    //                             fontWeight: FontWeight.w600,
    //                             fontSize: 37,
    //                             color: Color(0xff4F4F4F)),
    //                       )),
    //                       SizedBox(
    //                         height: 100,
    //                       ),
    //                       Column(
    //                         children: [
    //                           Container(
    //                             padding: EdgeInsets.only(left: 15, right: 15),
    //                             child: TextFormField(
    //                               validator: (String value) {
    //                                 if (value.isEmpty) {
    //                                   return "Sila masukkan nama pengguna";
    //                                 } else
    //                                   return null;
    //                               },
    //                               controller: usernameController,
    //                               style: TextStyle(
    //                                   color: Colors.black, fontSize: 18),
    //                               decoration: InputDecoration(
    //                                   hoverColor: Colors.yellow,
    //                                   icon: Icon(Icons.people_alt_sharp,
    //                                       color: Colors.black),
    //                                   hintText: 'Nama Pengguna',
    //                                   hintStyle: TextStyle(
    //                                       color:
    //                                           Colors.black.withOpacity(0.5))),
    //                             ),
    //                           ),
    //                           SizedBox(
    //                             height: 20,
    //                           ),
    //                           Container(
    //                               padding: EdgeInsets.only(left: 15, right: 15),
    //                               child: TextFormField(
    //                                 // key: widget.fieldKey,
    //                                 validator: _validatePassword,
    //                                 obscureText: _obscureText,
    //                                 cursorColor: Theme.of(context).cursorColor,
    //                                 maxLength: 16,
    //                                 controller: passwordController,
    //                                 // onFieldSubmitted: widget.onFieldSubmitted,
    //                                 decoration: InputDecoration(
    //                                   labelStyle: TextStyle(
    //                                       color: Colors.black.withOpacity(0.7)),
    //                                   icon:
    //                                       Icon(Icons.lock, color: Colors.black),
    //                                   filled: false,
    //                                   hintText: "Kata Laluan",
    //                                   suffixIcon: GestureDetector(
    //                                     dragStartBehavior:
    //                                         DragStartBehavior.down,
    //                                     onTap: () {
    //                                       if (_obscureText) {
    //                                         setState(() {
    //                                           _obscureText = false;
    //                                         });
    //                                       } else {
    //                                         setState(() {
    //                                           _obscureText = true;
    //                                         });
    //                                       }
    //                                     },
    //                                     child: Icon(
    //                                       _obscureText
    //                                           ? Icons.visibility_off
    //                                           : Icons.visibility,
    //                                     ),
    //                                   ),
    //                                 ),
    //                               )),
    //                           SizedBox(
    //                             height: 50,
    //                           ),
    //                           TestInternetAccess
    //                               ? SpinKitDoubleBounce(
    //                                   color: Colors.grey.shade700,
    //                                   size: 50.0,
    //                                 )
    //                               : InkWell(
    //                                   highlightColor: Colors.yellow,
    //                                   borderRadius: BorderRadius.circular(30),
    //                                   onTap: () async {
    //                                     isLoading = true;
    //                                     //   var connectivityResult =
    //                                     //       await (Connectivity()
    //                                     //           .checkConnectivity());
    //                                     //   if (connectivityResult ==
    //                                     //           ConnectivityResult.mobile ||
    //                                     //       connectivityResult ==
    //                                     //           ConnectivityResult.wifi) {
    //                                     //     _login();
    //                                     //   } else {
    //                                     //     ScaffoldMessenger.of(context)
    //                                     //         .showSnackBar(SnackBar(
    //                                     //       behavior: SnackBarBehavior.floating,
    //                                     //       content:
    //                                     //           Text('Tiada Sambungan Internet'),
    //                                     //       duration: Duration(seconds: 3),
    //                                     //     ));
    //                                     //   }
    //                                     FocusScopeNode currentFocus =
    //                                         FocusScope.of(context);
    //                                     currentFocus.unfocus();
    //                                     setState(() {
    //                                       TestInternetAccess = true;
    //                                     });
    //                                     try {
    //                                       final result = await InternetAddress
    //                                               .lookup('google.com')
    //                                           .timeout(
    //                                               const Duration(seconds: 3));
    //                                       if (result.isNotEmpty &&
    //                                           result[0].rawAddress.isNotEmpty) {
    //                                         setState(() {
    //                                           TestInternetAccess = false;
    //                                         });
    //                                         _login();
    //                                       }
    //                                     } catch (exception, stackTrace) {
    //                                       setState(() {
    //                                         TestInternetAccess = false;
    //                                       });
    //                                       await Sentry.captureException(
    //                                         exception,
    //                                         stackTrace: stackTrace,
    //                                       );
    //                                       ScaffoldMessenger.of(context)
    //                                           .showSnackBar(SnackBar(
    //                                         behavior: SnackBarBehavior.floating,
    //                                         content:
    //                                             Text('Tiada Akses Internet'),
    //                                         duration: Duration(seconds: 3),
    //                                       ));
    //                                     }
    //                                     setState(() {
    //                                       TestInternetAccess = false;
    //                                     });
    //                                   },
    //                                   child: isToLogin
    //                                       ? SpinKitDoubleBounce(
    //                                           color: Colors.grey.shade700,
    //                                           size: 50.0,
    //                                         )
    //                                       : Container(
    //                                           height: 50,
    //                                           alignment: Alignment.center,
    //                                           width: 350,
    //                                           decoration: BoxDecoration(
    //                                               color: Color(0xff3b6878),
    //                                               borderRadius:
    //                                                   BorderRadius.circular(30),
    //                                               boxShadow: [
    //                                                 BoxShadow(
    //                                                     color: Colors.black
    //                                                         .withOpacity(0.5),
    //                                                     blurRadius: 4,
    //                                                     spreadRadius: 0.5,
    //                                                     offset: Offset(0, 3))
    //                                               ]),
    //                                           child: Text(
    //                                             'Log Masuk',
    //                                             style: TextStyle(
    //                                                 color: Colors.white,
    //                                                 fontWeight: FontWeight.w500,
    //                                                 fontSize:  SizeConfig.textMultiplier * 2.5),
    //                                           ),
    //                                         ),
    //                                 ),
    //                           // Padding(
    //                           //   padding:
    //                           //       const EdgeInsets.fromLTRB(0, 25, 0, 10),
    //                           //   child: Row(
    //                           //     mainAxisAlignment: MainAxisAlignment.center,
    //                           //     children: [
    //                           //       Text(
    //                           //         'Bukan Ahli?',
    //                           //         style: TextStyle(color: Colors.black),
    //                           //       ),
    //                           //       SizedBox(
    //                           //         width: 5,
    //                           //       ),
    //                           //       InkWell(
    //                           //         onTap: () async {
    //                           //           var deviceID;
    //                           //           prefs = await SharedPreferences
    //                           //               .getInstance();
    //                           //           // deviceID = prefs.getString('DeviceID');
    //                           //           prefs.setString('DeviceID', null);
    //                           //           Navigator.of(context).pushNamed(
    //                           //             '/WelcomePage',
    //                           //           );
    //                           //         },
    //                           //         child: Text(
    //                           //           'Daftar Akaun',
    //                           //           style: TextStyle(
    //                           //               fontWeight: FontWeight.bold),
    //                           //         ),
    //                           //       )
    //                           //     ],
    //                           //   ),
    //                           // ),
    //                           SizedBox(
    //                             height: 20,
    //                           ),
    //                           InkWell(
    //                               onTap: () {
    //                                 Navigator.of(context)
    //                                     .pushReplacementNamed('/Home');
    //                               },
    //                               child: Text("bypass japp"))
    //                         ],
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  String? _validatePassword(String? value) {
    if (passwordController.text.isEmpty) {
      return 'Kata laluan diperlukan';
    }
    return null;
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

      var data = {};
      data["username"] = usernameController.text;
      data["password"] = passwordController.text;

      // Map data = {"username": "shafiqyajid", "password": "123456"};

      Object body = json.encode(data);
//'https://jendeladbp.my/wp-json/jwt-auth/v1/token'
      try {
        ApiService.logMasuk(body).then((response) async {
          final int statusCode = response.statusCode;

          if (response.statusCode == 401) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              width: 200,
              behavior: SnackBarBehavior.floating,
              content: Text('Session Expired. Please login again'),
              duration: Duration(seconds: 1),
            ));
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/Logout', (Route<dynamic> route) => false);
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
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/Logout', (Route<dynamic> route) => false);
            }
            var userRespBody = json.decode(userRes.body);
            User user = User.fromJson(userRespBody);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('currentUser', usernameController.text);
            // prefs.setString('passwordUser', passwordController.text);
            prefs.setString('token', data['token']);
            prefs.setInt('id', user.id ?? 0);

            Box<HiveBookAPI> bookAPIBox =
                Hive.box<HiveBookAPI>(GlobalVar.APIBook);
            await bookAPIBox.clear();

            // getKategori1Status = await getKategori1(data['token']);
            // getKategori2Status = await getKategori2(data['token']);
            // getKategori3Status = await getKategori3(data['token']);

            var wait1 =
                getKategori(context, data['token'], GlobalVar.kategori1);
            var wait2 =
                getKategori(context, data['token'], GlobalVar.kategori2);
            var wait3 =
                getKategori(context, data['token'], GlobalVar.kategori3);
            var wait4 =
                getKategori(context, data['token'], GlobalVar.kategori4);
            var wait5 =
                getKategori(context, data['token'], GlobalVar.kategori5);
            var wait6 =
                getKategori(context, data['token'], GlobalVar.kategori6);
            var wait8 =
                getKategori(context, data['token'], GlobalVar.kategori8);
            var wait9 =
                getKategori(context, data['token'], GlobalVar.kategori9);
            var wait10 =
                getKategori(context, data['token'], GlobalVar.kategori10);
            var wait11 =
                getKategori(context, data['token'], GlobalVar.kategori11);
            var wait12 =
                getKategori(context, data['token'], GlobalVar.kategori12);
            var wait13 =
                getKategori(context, data['token'], GlobalVar.kategori13);
            var wait14 =
                getKategori(context, data['token'], GlobalVar.kategori14);

            ApiService.maklumatPengguna(data['token']).then((response) async {
              var dataUSer;
              dataUSer = json.decode(response.body);
              prefs.setString('userID', dataUSer['id'].toString());
              prefs.setString('userData', json.encode(dataUSer));
            }).catchError((e) {
              // print(e);
            });

            if (await wait1 == true && await wait2 == true) {
              isToLogin = false;

              Future.delayed(const Duration(seconds: 1)).then((value) {
                Navigator.of(context).pushReplacementNamed('/Home');
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('Something Happen'),
                duration: Duration(seconds: 3),
              ));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Nama Pengguna atau Kata Laluan Salah @ Code:$statusCode'),
              duration: const Duration(seconds: 3),
            ));

            setState(() {
              isToLogin = false;
              usernameController.text = "";
              passwordController.text = "";
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
