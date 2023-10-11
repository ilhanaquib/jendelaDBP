import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jendela_dbp/components/bookshelf/bookshelf.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';
import 'package:jendela_dbp/controllers/getBooksFromApi.dart';
import 'package:jendela_dbp/controllers/globalVar.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:jendela_dbp/stateManagement/blocs/imagePickerBloc.dart';
import 'package:jendela_dbp/stateManagement/cubits/AuthCubit.dart';
import 'package:jendela_dbp/stateManagement/states/authState.dart';
import 'package:jendela_dbp/view/authentication/signin.dart';
import 'package:jendela_dbp/model/userModel.dart';
import 'package:jendela_dbp/view/pages/userIcon.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Box<HiveBookAPI> APIBook = Hive.box<HiveBookAPI>(GlobalVar.APIBook);
  List<int> kategori1Books = [];
  bool isLoading = true;
  final User user = User();

  var allProduct;

  Future<bool> getAllProduct() async {
    var value = await SharedPreferences.getInstance();
    var token = value.getString('token');

    if (bookAPIBox.isEmpty || bookAPIBox.length == 0) {
      setState(() {
        isLoading = true;
      });

      bookAPIBox.clear();
      await getKategori(context, token, GlobalVar.kategori1);
    }

    getKategoriFromAPI();

    setState(() {
      isLoading = false;
    });
    return true;
  }

  void getKategoriFromAPI() {
    print('object');
    kategori1Books = APIBook.keys
        .cast<int>()
        .where(
            (key) => APIBook.get(key)!.product_category == GlobalVar.kategori1)
        .toList();
  }

  void _updateAppBar() {
    setState(() {
      // Rebuild the app bar to reflect the changes
    });
  }

  @override
  void initState() {
    super.initState();
    allProduct = getAllProduct();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          width: 200,
                          behavior: SnackBarBehavior.floating,
                          content: Text(state.message ?? ''),
                          duration: const Duration(seconds: 5),
                        ),
                      );
                    }
                  }
                  if (state is AuthLoaded) {
                    if (state.message != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        width: 200,
                        behavior: SnackBarBehavior.floating,
                        content: Text(state.message ?? ''),
                        duration: Duration(seconds: 5),
                      ));
                    }
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoaded) {
                    if (state.isAuthenticated == true) {
                      return _userProfileWidget(context);
                    }
                  }

                  if (state is AuthLoading) {
                    return Container(
                      height: 400,
                      child: Center(
                        child: LoadingAnimationWidget.discreteCircle(
                          color: DbpColor().jendelaGray,
                          secondRingColor:
                              DbpColor().jendelaGreen,
                          thirdRingColor:
                              DbpColor().jendelaOrange,
                          size: 30.0,
                        ),
                      ),
                    );
                  }

                  return _signInFirst();
                }),
          ),
        ),
        onRefresh: () async {
          BlocProvider.of<AuthCubit>(context).getUser();
        },
      ),
    );
  }

  Widget _userProfileWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Account'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        withNavBar: false,
                        screen: BlocProvider.value(
                          value: context.read<ImageBloc>(),
                          child: UserHomeScreen(
                            updateAppBar: _updateAppBar,
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: context
                              .watch<ImageBloc>()
                              .selectedImageProvider ??
                          const AssetImage('assets/images/logo.png'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name!),
                        Text(user.email!),
                        Text(user.country!),
                        Text(user.city!),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: SizedBox(
              child: Table(
                border: const TableBorder(
                  top: BorderSide(width: 1),
                  right: BorderSide(width: 1),
                  bottom: BorderSide(width: 1),
                  left: BorderSide(width: 1),
                  horizontalInside: BorderSide(width: 1),
                ),
                children: const <TableRow>[
                  TableRow(
                    children: <Widget>[
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Text('Order'),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Text('Date'),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Text('Status'),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Text('Total'),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Text('#61148'),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Text('15/8/2023'),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Text('Completed'),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Text('RM0.00 for 1 item'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              child: bookShelf(context, GlobalVar.kategori1Title,
                  GlobalVar.kategori1, kategori1Books, APIBook),
            ),
          ),
        ],
      ),
    );
  }

  Widget _signInFirst() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 150),
      child: Center(
        child: Column(
          children: [
            const Text('Uh oh, you haven\'t signed in yet'),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Please ',
                    style: TextStyle(
                        color: Colors.black), // Customize the style if needed
                  ),
                  TextSpan(
                    text: 'sign in',
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        PersistentNavBarNavigator.pushNewScreen(context,
                            withNavBar: false, screen: const Signin());
                      },
                  ),
                  const TextSpan(
                    text: ' to continue',
                    style: TextStyle(
                        color: Colors.black), // Customize the style if needed
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
