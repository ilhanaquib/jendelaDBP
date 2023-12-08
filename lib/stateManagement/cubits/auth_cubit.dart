// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
// import 'dart:html'
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:jendela_dbp/api_services.dart';
import 'package:jendela_dbp/controllers/global_var.dart';
import 'package:jendela_dbp/model/user_model.dart';
import 'package:jendela_dbp/stateManagement/states/auth_state.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());
  bool hideNavigationBar = false;

  Future<bool> getUserLoginOrNot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentUser = prefs.getString('currentUser');
    return currentUser == null || currentUser == "" ? false : true;
  }

  Future<bool> setHideNavigationBar({required bool hideNavBar}) async {
    try {
      emit(const AuthLoading());
      hideNavigationBar = hideNavBar;
      if (await getUserLoginOrNot()) {
        emit(AuthLoaded(
            hideNavigationBar: hideNavigationBar, isAuthenticated: true));
      } else {
        emit(AuthError(
            hideNavigationBar: hideNavigationBar, isAuthenticated: false));
      }

      return true;
    } catch (e) {
      emit(AuthError(message: e.toString()));
      return false;
    }
  }

  Future<bool> update(
      {required String name,
      required String email,
      required String firstName,
      required String lastName,
      String? currentPassword,
      String? newPassword,
      String? confirmPassword}) async {
    try {
      User? user = state.user;
      user?.name = name;
      user?.email = email;
      user?.firstName = firstName;
      user?.lastName = lastName;
      String? message = state.message;
      bool? hideNavigationBar = state.hideNavigationBar;
      bool? isAuthenticated = state.isAuthenticated;
      emit(AuthLoading(
          user: user,
          message: message,
          hideNavigationBar: hideNavigationBar,
          isAuthenticated: isAuthenticated));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int id = prefs.getInt('id') ?? 0;
      String token = prefs.getString('token') ?? '';
      Object body = Object();
      bool isChangePassword = false;
      // validate new password
      if (newPassword != '') {
        if (newPassword == confirmPassword) {
          isChangePassword = true;
          body = json.encode({
            "name": user?.name,
            "email": user?.email,
            "first_name": user?.firstName,
            "last_name": user?.lastName,
            "password": newPassword
          });
        } else {
          emit(AuthError(
              user: user,
              isAuthenticated: isAuthenticated,
              hideNavigationBar: hideNavigationBar,
              message:
                  'Kata Laluan Tidak Sepadan Dengan "Sahkan Kata Laluan Baru"'));
          return false;
        }
      } else {
        body = json.encode({
          "name": user?.name,
          "email": user?.email,
          "first_name": user?.firstName,
          "last_name": user?.lastName
        });
      }
      if (id == 0) {
        emit(AuthLoaded(
            isAuthenticated: false,
            message: message,
            hideNavigationBar: hideNavigationBar));
      } else {
        final response = await http.put(
            Uri.https(GlobalVar.baseURLDomain, '/wp-json/wp/v2/users/$id',
                {"context": "edit"}),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ' + token,
            },
            body: body);

        // User? user = await getUser();
        if (response.statusCode >= 200 && response.statusCode <= 299) {
          String message;
          if (isChangePassword == true) {
            message = 'Maklumat Dan Kata Laluan Dikemas Kini';
          } else {
            message = 'Maklumat Dikemas Kini';
          }
          emit(AuthLoaded(
              hideNavigationBar: hideNavigationBar,
              message: message,
              isAuthenticated: true,
              user: user));
        } else {
          emit(AuthError(
              isAuthenticated: false,
              hideNavigationBar: hideNavigationBar,
              message: 'Error ' +
                  response.statusCode.toString() +
                  ' ' +
                  (response.reasonPhrase ?? '')));
        }
      }
      return true;
    } catch (error) {
      emit(AuthError(message: error.toString()));
      return false;
    }
  }

  Future<User?> getUser() async {
    User? user = state.user;
    bool? hideNavigationBar = state.hideNavigationBar;
    bool? isAuthenticated = state.isAuthenticated;
    String? message = state.message;
    try {
      emit(AuthLoading(
          user: user,
          hideNavigationBar: hideNavigationBar,
          isAuthenticated: isAuthenticated,
          message: message));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int id = prefs.getInt('id') ?? 0;
      String token = prefs.getString('token') ?? '';
      if (id == 0) {
        emit(AuthLoaded(
            hideNavigationBar: hideNavigationBar,
            message: message,
            isAuthenticated: false));
        return null;
      } else {
        final response = await http.get(
            Uri.https(GlobalVar.baseURLDomain, '/wp-json/wp/v2/users/me',
                {"context": "edit"}),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ' + token,
            });
        if (response.statusCode == 200) {
          user = User.fromJson(json.decode(response.body));
          emit(AuthLoaded(
              user: user,
              isAuthenticated: isAuthenticated,
              hideNavigationBar: hideNavigationBar));
          return user;
        } else {
          emit(AuthError(
              isAuthenticated: false,
              hideNavigationBar: hideNavigationBar,
              message: 'Error ' + response.statusCode.toString()));
          return null;
        }
      }
    } catch (error) {
      emit(AuthError(
          isAuthenticated: false,
          hideNavigationBar: hideNavigationBar,
          message: error.toString()));
      return null;
    }
  }

  Future<void> signup(String username, String email, String password,
      String confirmPassword) async {
    emit(AuthLoading(
        hideNavigationBar: state.hideNavigationBar,
        user: state.user,
        isAuthenticated: state.isAuthenticated));
    // Validate
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      emit(AuthError(
          hideNavigationBar: state.hideNavigationBar,
          user: state.user,
          message: "Semua input diperlukan",
          isAuthenticated: state.isAuthenticated));
      return;
    }
    if (password.length < 6) {
      emit(AuthError(
          hideNavigationBar: state.hideNavigationBar,
          user: state.user,
          message: "Panjang kata laluan hendaklah lebih dari 6.",
          isAuthenticated: state.isAuthenticated));
    }
    if (password != confirmPassword) {
      emit(AuthError(
          hideNavigationBar: state.hideNavigationBar,
          user: state.user,
          message: "Kata laluan tidak sempadan dengan kata laluan pengesahan.",
          isAuthenticated: state.isAuthenticated));
      return;
    }
    // Signup
    try {
      var data = {};
      data["username"] = username;
      data["email"] = email;
      data["password"] = password;
      data["confirm_password"] = confirmPassword;
      Object body = json.encode(data);
      var dataheader = {};
      dataheader["Content-Type"] = "application/json";
      //Object header = json.encode(dataheader);
      ApiService.register(body).then((response) async {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          var userRespBody = json.decode(response.body);
          Response userRes =
              await ApiService.maklumatPengguna(userRespBody['token']);
          if (userRes.statusCode >= 200 && userRes.statusCode < 300) {
            User user = User.fromJson(json.decode(userRes.body));
            await saveAuthUserToLocal(
                username: username, user: user, token: userRespBody['token']);
            emit(AuthLoaded(
                hideNavigationBar: state.hideNavigationBar,
                user: user,
                message: null,
                isAuthenticated: true));
          } else {
            var errbody = json.decode(userRes.body);
            emit(AuthError(
                hideNavigationBar: state.hideNavigationBar,
                user: state.user,
                message: errbody['message'],
                isAuthenticated: state.isAuthenticated));
          }
        } else {
          var errbody = json.decode(response.body);
          emit(AuthError(
              hideNavigationBar: state.hideNavigationBar,
              user: state.user,
              message: errbody['message'],
              isAuthenticated: state.isAuthenticated));
        }
      });
    } catch (e) {
      emit(AuthError(
          hideNavigationBar: state.hideNavigationBar,
          user: state.user,
          message: e.toString(),
          isAuthenticated: state.isAuthenticated));
    }
  }

  Future<void> appleSignUp(BuildContext context) async {
    //String? message = state.message;
    bool? hideNavigationBar = state.hideNavigationBar;
    try {
      // get apple is signin status
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isAppleSignin', true);
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          //  Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
          clientId: GlobalVar.appleSigninClientId2,
          redirectUri: Uri.parse(
            GlobalVar.appleSigninRedirectUri2,
          ),
        ),
      );
      // This is the endpoint that will convert an authorization code obtained
      // via Sign in with Apple into a session in your system
      final signInWithAppleEndpoint = Uri(
        scheme: 'https',
        host: GlobalVar.appleSigninHost,
        path: GlobalVar.appleSigninPath,
        queryParameters: <String, String>{
          'code': credential.authorizationCode,
          if (credential.givenName != null) 'firstName': credential.givenName!,
          if (credential.familyName != null) 'lastName': credential.familyName!,
          'useBundleId': Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
          if (credential.state != null) 'state': credential.state!,
          if (credential.identityToken != null)
            'id_token': credential.identityToken!,
          if (credential.userIdentifier != null)
            'userIdentifier': credential.userIdentifier!,
          if (credential.email != null) 'email': credential.email!,
          if (Platform.isIOS) 'device': 'ios'
        },
      );

      emit(const AuthLoading());

      final session = await http.Client().post(
        signInWithAppleEndpoint,
      );

      // If we got this far, a session based on the Apple ID credential has been created in your system,
      // and you can now set this as the app's session
      if (session.statusCode == 200) {
        var data = json.decode(session.body);
        Response userRes = await ApiService.maklumatPengguna(data['token']);
        if (userRes.statusCode == 200) {
          // Success response
          var userRespBody = json.decode(userRes.body);
          User user = User.fromJson(userRespBody);
          await saveAuthUserToLocal(
              username: user.email ?? 'pengguna',
              user: user,
              token: data['token']);
          emit(AuthLoaded(
              isAuthenticated: true,
              user: user,
              hideNavigationBar: hideNavigationBar));
        } else {
          // Fail response

          emit(AuthError(
              isAuthenticated: false,
              hideNavigationBar: hideNavigationBar,
              message: 'Session Expired. Please login again'));
          if (!context.mounted) return;
          logout(context);
        }
      } else {
        if (session.statusCode != 401) {
          emit(AuthError(
              isAuthenticated: false,
              hideNavigationBar: hideNavigationBar,
              message: 'Error ' + session.statusCode.toString()));
        }
        if (!context.mounted) return;
        logout(context);
      }
    } catch (err) {
      if (err is SignInWithAppleAuthorizationException) {
        if (err.message.contains("error 1000") ||
            err.message.contains("error 1001")) {
          emit(AuthError(
              isAuthenticated: false, hideNavigationBar: hideNavigationBar));
        } else {
          emit(AuthError(
              isAuthenticated: false,
              hideNavigationBar: hideNavigationBar,
              message: err.toString()));
        }
      } else {
        emit(AuthError(
            isAuthenticated: false, hideNavigationBar: hideNavigationBar));
      }
      if (!context.mounted) return;
      logout(context);
    }
  }

  Future<Map> login(context,
      {required bool isToLogin,
      required GlobalKey<FormState> formKey,
      required TextEditingController usernameController,
      required TextEditingController passwordController}) async {
    isToLogin = true;
    final form = formKey.currentState;
    String? message = state.message;
    bool? isAuthenticated = state.isAuthenticated;
    bool? hideNavigationBar = state.hideNavigationBar;
    User? user = state.user;
    emit(AuthLoading(
        user: user,
        isAuthenticated: isAuthenticated,
        hideNavigationBar: hideNavigationBar,
        message: message));
    if (!form!.validate()) {
      isToLogin = false;
      emit(AuthError(
          isAuthenticated: false,
          message: "Wrong email or password.",
          hideNavigationBar: hideNavigationBar));
    } else {
      form.save();
      var data = {};
      data["username"] = usernameController.text;
      data["password"] = passwordController.text;
      Object body = json.encode(data);
      try {
        ApiService.logMasuk(body).then((response) async {
          final int statusCode = response.statusCode;
          if (response.statusCode >= 200 && response.statusCode <= 299) {
            // Success response
            // ignore: prefer_typing_uninitialized_variables
            var data;
            data = json.decode(response.body);
            Response userRes = await ApiService.maklumatPengguna(data['token']);
            if (userRes.statusCode >= 300) {
              emit(AuthError(
                  isAuthenticated: false,
                  hideNavigationBar: hideNavigationBar,
                  message: 'Session Expired. Please login again'));
              return {
                'isToLogin': isToLogin,
                'formKey': formKey,
                'usernameController': usernameController,
                'passwordController': passwordController,
              };
            }
            var userRespBody = json.decode(userRes.body);
            User user = User.fromJson(userRespBody);
            await saveAuthUserToLocal(
                username: usernameController.text,
                user: user,
                token: data['token']);

            // Box<BookAPI> bookAPIBox = Hive.box<BookAPI>(GlobalVar.APIBook);
            // await bookAPIBox.clear();

            // await getKategori(context, data['token'], GlobalVar.kategori1);
            // await getKategori(context, data['token'], GlobalVar.kategori2);
            // await getKategori(context, data['token'], GlobalVar.kategori3);
            // await getKategori(context, data['token'], GlobalVar.kategori4);
            // await getKategori(context, data['token'], GlobalVar.kategori5);
            // await getKategori(context, data['token'], GlobalVar.kategori6);
            // await getKategori(context, data['token'], GlobalVar.kategori8);
            // await getKategori(context, data['token'], GlobalVar.kategori9);
            // await getKategori(context, data['token'], GlobalVar.kategori10);
            // await getKategori(context, data['token'], GlobalVar.kategori11);
            // await getKategori(context, data['token'], GlobalVar.kategori12);
            // await getKategori(context, data['token'], GlobalVar.kategori13);
            // await getKategori(context, data['token'], GlobalVar.kategori14);

            isToLogin = false;
            emit(AuthLoaded(
                isAuthenticated: true,
                hideNavigationBar: hideNavigationBar,
                user: user));
          } else if (response.statusCode >= 300) {
            // Fail response
            emit(AuthError(
                isAuthenticated: false,
                hideNavigationBar: hideNavigationBar,
                message: 'Session Expired. Please login again'));
            return {
              'isToLogin': isToLogin,
              'formKey': formKey,
              'usernameController': usernameController,
              'passwordController': passwordController,
            };
          } else {
            // Fail response
            emit(AuthError(
                isAuthenticated: false,
                hideNavigationBar: hideNavigationBar,
                message: 'Nama Pengguna atau Kata Laluan Salah @ Code:' +
                    statusCode.toString()));

            isToLogin = false;
            usernameController.text = "";
            passwordController.text = "";
          }
        });
      } catch (exception, stackTrace) {
        isToLogin = false;
        emit(AuthError(
            isAuthenticated: isAuthenticated,
            user: user,
            hideNavigationBar: hideNavigationBar,
            message: exception.toString()));
        await Sentry.captureException(
          exception,
          stackTrace: stackTrace,
        );
      }
    }
    return {
      'isToLogin': isToLogin,
      'formKey': formKey,
      'usernameController': usernameController,
      'passwordController': passwordController,
    };
  }

  Future<SharedPreferences> saveAuthUserToLocal(
      {required User user,
      required String username,
      required String token}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('currentUser', username);
    prefs.setString('token', token);
    prefs.setInt('id', user.id ?? 0);
    prefs.setString('userID', user.id.toString());
    prefs.setString('userData', user.toJson());
    return prefs;
  }

  Future<bool> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('currentUser', '');
    prefs.setString('token', '');
    prefs.setInt('id', 0);
    User? user = state.user;
    bool? isAuthenticated = state.isAuthenticated;
    bool? hideNavigationBar = state.hideNavigationBar;
    //String? message = state.message;
    emit(AuthLoading(
        isAuthenticated: isAuthenticated,
        user: user,
        hideNavigationBar: hideNavigationBar));
    try {
      emit(const AuthLoaded(isAuthenticated: false));
      // Navigator.of(context).pushReplacementNamed(
      //   '/MyApp',
      // );
    } catch (e, st) {
      await Sentry.captureException(
        e,
        stackTrace: st,
      );
    }
    return true;
  }
}
