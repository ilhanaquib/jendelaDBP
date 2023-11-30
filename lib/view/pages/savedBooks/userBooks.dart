import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:jendela_dbp/components/DBPImportedWidgets/notFoundCard.dart';
import 'package:jendela_dbp/components/bukuDibeli/getPurchase.dart';
import 'package:jendela_dbp/components/bukuDibeli/purchasedBookCover.dart';
import 'package:jendela_dbp/components/user/loginCard.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';
import 'package:jendela_dbp/controllers/globalVar.dart';
import 'package:jendela_dbp/hive/models/hivePurchasedBookModel.dart';
import 'package:jendela_dbp/stateManagement/blocs/poductBloc.dart';
import 'package:jendela_dbp/stateManagement/cubits/AuthCubit.dart';
import 'package:jendela_dbp/stateManagement/cubits/connectionCubit.dart';
import 'package:jendela_dbp/stateManagement/events/productEvent.dart';
import 'package:jendela_dbp/stateManagement/states/authState.dart';
import 'package:jendela_dbp/stateManagement/states/productState.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UserBooks extends StatefulWidget {
  UserBooks() : super();

  _PurchasedBooks createState() => _PurchasedBooks();
}

class _PurchasedBooks extends State<UserBooks> {
  ProductBloc purchasedBookBloc = ProductBloc();
  ConnectionCubit conCubit = ConnectionCubit();
  Box<HivePurchasedBook> purchasedBookBox =
      Hive.box<HivePurchasedBook>(GlobalVar.PuchasedBook);

  @override
  void initState() {
    super.initState();
    purchasedBookBloc.add(ProductPurchasedBooksFetch());
  }

  @override
  void dispose() {
    purchasedBookBloc.close();
    super.dispose();
  }

  DbpColor colors = DbpColor();
  Widget build(BuildContext context) {
    AuthCubit _authCubit = BlocProvider.of<AuthCubit>(context);
    conCubit.checkConnection(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // leading: OutlinedButton(
        //   child: Text('da'),
        //   onPressed: () {
        //     print(purchasedBookBox.length);
        //   },
        // ),
        centerTitle: true,
        title: const Text(
          'Buku Dibeli',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          conCubit.checkConnection(context);
          // _authCubit.getUser();
          purchasedBookBloc.add(ProductPurchasedBooksFetch());
          // _refreshController.refreshCompleted();
        },
        child: BlocConsumer<AuthCubit, AuthState>(
          bloc: _authCubit,
          listener: (context, state) {},
          builder: (context, state) {
            if (state is AuthError) {
              return LoginCard();
            }
            if (state is AuthLoaded) {
              if (state.isAuthenticated == true) {
                return BlocConsumer<ProductBloc, ProductState>(
                  bloc: purchasedBookBloc,
                  listener: (context, state) {
                    if (state is ProductError) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(state.message ?? ''),
                        duration: Duration(seconds: 3),
                      ));
                    }
                  },
                  builder: (context, state) {
                    if (state is ProductLoaded) {
                      if ((state.dataBooks?.length ?? 0) > 0) {
                        List<Widget> listOfWidget = [];
                        state.dataBooks!.forEach((index) {
                          HivePurchasedBook? value =
                              bookPurchaseBox.get(index) ?? HivePurchasedBook();
                          listOfWidget.add(BookPurchasedCoverCard(
                            context,
                            purchasedBook: value,
                          ));
                        });
                        // return
                        return GridView(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio: 2 / 3),
                          children: listOfWidget,
                        );
                      } else {
                        return SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Container(
                                height:
                                    MediaQuery.maybeOf(context)?.size.height,
                                child: Center(child: NotFoundCard())));
                      }
                    }

                    if (state is ProductLoading) {
                      return LoadingAnimationWidget.discreteCircle(
                        color: DbpColor().jendelaGray,
                        secondRingColor: DbpColor().jendelaGreen,
                        thirdRingColor: DbpColor().jendelaOrange,
                        size: 50.0,
                      );
                    }

                    return LoginCard();
                  },
                );
              }
              return LoginCard();
            }
            return LoadingAnimationWidget.discreteCircle(
              color: DbpColor().jendelaGray,
              secondRingColor: DbpColor().jendelaGreen,
              thirdRingColor: DbpColor().jendelaOrange,
              size: 50.0,
            );
          },
        ),
      ),
    );
  }
}
