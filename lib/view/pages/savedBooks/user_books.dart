import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:jendela_dbp/components/DBPImportedWidgets/not_found_card.dart';
import 'package:jendela_dbp/components/bukuDibeli/get_purchase.dart';
import 'package:jendela_dbp/components/bukuDibeli/purchased_book_cover.dart';
import 'package:jendela_dbp/components/user/login_card.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/controllers/global_var.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:jendela_dbp/hive/models/hivePurchasedBookModel.dart';
import 'package:jendela_dbp/stateManagement/blocs/poduct_bloc.dart';
import 'package:jendela_dbp/stateManagement/cubits/auth_cubit.dart';
import 'package:jendela_dbp/stateManagement/cubits/connection_cubit.dart';
import 'package:jendela_dbp/stateManagement/events/product_event.dart';
import 'package:jendela_dbp/stateManagement/states/auth_state.dart';
import 'package:jendela_dbp/stateManagement/states/product_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UserBooks extends StatefulWidget {
  const UserBooks({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserBooks createState() => _UserBooks();
}

class _UserBooks extends State<UserBooks> {
  ProductBloc purchasedBookBloc = ProductBloc();
  ConnectionCubit conCubit = ConnectionCubit();
  Box<HivePurchasedBook> beliBox =
      Hive.box<HivePurchasedBook>(GlobalVar.puchasedBook);
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
  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.maybeOf(context)!.size;
    AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    conCubit.checkConnection(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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
          bloc: authCubit,
          listener: (context, state) {},
          builder: (context, state) {
            if (state is AuthError) {
              return const LoginCard();
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
                        duration: const Duration(seconds: 3),
                      ));
                    }
                  },
                  builder: (context, state) {
                    if (state is ProductLoaded) {
                      if ((state.dataBooks?.length ?? 0) > 0) {
                        List<Widget> listOfWidget = [];
                        for (var index in state.dataBooks!) {
                          HivePurchasedBook? value =
                              bookPurchaseBox.get(index) ?? HivePurchasedBook();
                          listOfWidget.add(BookPurchasedCoverCard(
                            context,
                            purchasedBook: value,
                          ));
                        }
                        // return
                        return ListView(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          children: listOfWidget,
                        );
                      } else {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.maybeOf(context)?.size.height,
                            child: const Center(
                              child: NotFoundCard(),
                            ),
                          ),
                        );
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

                    return const LoginCard();
                  },
                );
              }
              return const LoginCard();
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
    // child: Container(
    //   child: Padding(
    //     padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
    //     child: Column(
    //       children: [
    //         Expanded(
    //           child: BlocConsumer<AuthCubit, AuthState>(
    //             bloc: _authCubit,
    //             listener: (context, state) {},
    //             builder: (context, state) {
    //               if (state is AuthError) {
    //                 return LoginCard();
    //               }
    //               if (state is AuthLoaded) {
    //                 if (state.isAuthenticated == true) {
    //                   return BlocConsumer<ProductBloc, ProductState>(
    //                     bloc: purchasedBookBloc,
    //                     listener: (context, state) {
    //                       if (state is ProductError) {
    //                         ScaffoldMessenger.of(context)
    //                             .showSnackBar(SnackBar(
    //                           behavior: SnackBarBehavior.floating,
    //                           content: Text(state.message ?? ''),
    //                           duration: Duration(seconds: 3),
    //                         ));
    //                       }
    //                     },
    //                     builder: (context, state) {
    //                       if (state is ProductError) {
    //                         return LoadingCard();
    //                       }
    //                       if (state is ProductLoaded) {
    //                         if ((state.dataBooks?.length ?? 0) > 0) {
    //                           List<Widget> listOfWidget = [];
    //                           state.dataBooks!.forEach((index) {
    //                             BookPurchase? value =
    //                                 bookPurchaseBox.get(index) ??
    //                                     BookPurchase();
    //                             listOfWidget.add(BookPurchasedCoverCard(
    //                               context,
    //                               bookPurchase: value,
    //                             ));
    //                           });
    //                           return GridView(
    //                             physics: BouncingScrollPhysics(
    //                                 parent:
    //                                     AlwaysScrollableScrollPhysics()),
    //                             children: listOfWidget,
    //                             gridDelegate:
    //                                 SliverGridDelegateWithFixedCrossAxisCount(
    //                                     crossAxisCount: 3,
    //                                     crossAxisSpacing: 10.0,
    //                                     mainAxisSpacing: 10.0,
    //                                     childAspectRatio: 2 / 3),
    //                           );
    //                         } else {
    //                           return Center(child: NotFoundCard());
    //                         }
    //                       }
    //                       return LoginCard();
    //                     },
    //                   );
    //                 }
    //                 return LoginCard();
    //               }
    //               return LoadingCard();
    //             },
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // ),
  }
}
