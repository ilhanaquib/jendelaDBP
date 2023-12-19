import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/components/bookshelf/carousel_title.dart';
import 'package:jendela_dbp/components/user/login_card.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/model/user_model.dart';
import 'package:jendela_dbp/stateManagement/cubits/auth_cubit.dart';
import 'package:jendela_dbp/stateManagement/states/auth_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  DbpColor colors = DbpColor();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userFirstNameController =
      TextEditingController();
  final TextEditingController _userLastNameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userNewPasswordController =
      TextEditingController();
  final TextEditingController _userConfirmPasswordController =
      TextEditingController();
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _userFirstNameFocusNode = FocusNode();
  final FocusNode _userLastNameFocusNode = FocusNode();
  final FocusNode _userEmailFocusNode = FocusNode();
  final FocusNode _userNewPasswordFocusNode = FocusNode();
  final FocusNode _userConfirmPasswordFocusNode = FocusNode();
  int runCount = 1;
  String? currentUser = '';
  AuthCubit authCubit = AuthCubit();

  @override
  void initState() {
    super.initState();
    _userNewPasswordController.text = '';
    _userConfirmPasswordController.text = '';
    authCubit.getUserLoginOrNot();
    authCubit.getUser();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _userFirstNameController.dispose();
    _userLastNameController.dispose();
    _userEmailController.dispose();
    _userNewPasswordController.dispose();
    _userConfirmPasswordController.dispose();
    _userNameFocusNode.dispose();
    _userFirstNameFocusNode.dispose();
    _userLastNameFocusNode.dispose();
    _userEmailFocusNode.dispose();
    _userNewPasswordFocusNode.dispose();
    _userConfirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Perincian Akaun',
        ),
      ),
      body: RefreshIndicator(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: BlocConsumer<AuthCubit, AuthState>(
                bloc: BlocProvider.of<AuthCubit>(context),
                listener: (context, state) {
                  if (state is AuthError) {
                    if (state.message != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        width: 200,
                        behavior: SnackBarBehavior.floating,
                        content: Text(state.message ?? ''),
                        duration: const Duration(seconds: 5),
                      ));
                    }
                  }
                  if (state is AuthLoaded) {
                    if (state.message != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        width: 200,
                        behavior: SnackBarBehavior.floating,
                        content: Text(state.message ?? ''),
                        duration: const Duration(seconds: 5),
                      ));
                    }
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoaded) {
                    authCubit.getUserLoginOrNot();
                    authCubit.getUser();
                    _userNameController.text = state.user!.name ?? '';
                    _userFirstNameController.text = state.user!.firstName ?? '';
                    _userLastNameController.text = state.user!.lastName ?? '';
                    _userEmailController.text = state.user!.email ?? '';
                    return _userProfileWidget(context,
                        user: state.user ?? User());
                  }

                  if (state is AuthLoading) {
                    return SizedBox(
                      height: 400,
                      child: Center(
                        child: LoadingAnimationWidget.discreteCircle(
                          color: DbpColor().jendelaGray,
                          secondRingColor: DbpColor().jendelaGreen,
                          thirdRingColor: DbpColor().jendelaOrange,
                          size: 50.0,
                        ),
                      ),
                    );
                  }

                  return _userLoginWidget();
                }),
          ),
        ),
        onRefresh: () async {
          BlocProvider.of<AuthCubit>(context).getUser();
        },
      ),
    );
  }

  Widget _userProfileWidget(BuildContext context, {required User user}) {
    return Column(
      children: [
        TextFormField(
          controller: _userFirstNameController,
          focusNode: _userFirstNameFocusNode,
          decoration: const InputDecoration(
            icon: Icon(Icons.person),
            label: Text('Nama Awal (First Name)'),
          ),
          onEditingComplete: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              currentFocus.focusedChild!.unfocus();
            }
          },
        ),
        TextFormField(
          controller: _userLastNameController,
          focusNode: _userLastNameFocusNode,
          decoration: const InputDecoration(
            icon: Icon(Icons.person),
            label: Text('Nama Akhir (Last Name)'),
          ),
          onEditingComplete: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              currentFocus.focusedChild!.unfocus();
            }
          },
        ),
        TextFormField(
          controller: _userNameController,
          focusNode: _userNameFocusNode,
          decoration: const InputDecoration(
            icon: Icon(Icons.person),
            label: Text('Nama'),
          ),
          onEditingComplete: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              currentFocus.focusedChild!.unfocus();
            }
          },
        ),
        TextFormField(
          controller: _userEmailController,
          focusNode: _userEmailFocusNode,
          decoration: const InputDecoration(
            icon: Icon(Icons.mail),
            label: Text('Alamat emel'),
          ),
          onEditingComplete: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              currentFocus.focusedChild!.unfocus();
            }
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
          child: Divider(
            color: Colors.green,
            thickness: 0.2,
            height: 10,
          ),
        ),
        CarouselTitle(
          title: 'Tukar Kata Laluan',
          seeAllText: "",
          seeAllOnTap: () {},
        ),
        TextFormField(
          controller: _userNewPasswordController,
          focusNode: _userNewPasswordFocusNode,
          decoration: const InputDecoration(
            icon: Icon(Icons.security_rounded),
            label: Text('Kata Laluan Baru'),
          ),
          onEditingComplete: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              currentFocus.focusedChild!.unfocus();
            }
          },
        ),
        TextFormField(
          controller: _userConfirmPasswordController,
          focusNode: _userConfirmPasswordFocusNode,
          decoration: const InputDecoration(
            icon: Icon(Icons.security_rounded),
            label: Text('Sahkan Kata Laluan Baru'),
          ),
          onEditingComplete: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              currentFocus.focusedChild!.unfocus();
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: OutlinedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  DbpColor().jendelaGreen), // Green background
              overlayColor: MaterialStateProperty.all<Color>(
                  Colors.transparent), // No overlay color
              side: MaterialStateProperty.all<BorderSide>(BorderSide(
                  color: DbpColor().jendelaGreen, width: 2)), // Green border
            ),
            child: const Text(
              'Kemas Kini',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              BlocProvider.of<AuthCubit>(context).update(
                  name: _userNameController.text,
                  firstName: _userFirstNameController.text,
                  lastName: _userLastNameController.text,
                  email: _userEmailController.text,
                  newPassword: _userNewPasswordController.text,
                  confirmPassword: _userConfirmPasswordController.text);
            },
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Colors.red), // Green background
            overlayColor: MaterialStateProperty.all<Color>(
                Colors.transparent), // No overlay color
            side: MaterialStateProperty.all<BorderSide>(
              const BorderSide(color: Colors.red, width: 2),
            ), // Green border
          ),
          onPressed: () {
            BlocProvider.of<AuthCubit>(context).logout(context);
            Navigator.pushNamed(context, '/home');
          },
          child: const Text(
            'Log Keluar',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget _userLoginWidget() {
    return LoginCard(
      text: 'Sila log masuk untuk lihat akaun anda',
    );
  }
}
