import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:jendela_dbp/components/DBPImportedWidgets/notFoundCard.dart';
import 'package:jendela_dbp/components/bukuDibeli/getPurchase.dart';
import 'package:jendela_dbp/components/bukuDibeli/purchasedBookCover.dart';
import 'package:jendela_dbp/components/userBooks/purchaseSignin.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';
import 'package:jendela_dbp/hive/models/hivePurchasedBookModel.dart';
import 'package:jendela_dbp/stateManagement/blocs/poductBloc.dart';
import 'package:jendela_dbp/stateManagement/cubits/AuthCubit.dart';
import 'package:jendela_dbp/stateManagement/cubits/connectionCubit.dart';
import 'package:jendela_dbp/stateManagement/events/productEvent.dart';
import 'package:jendela_dbp/stateManagement/states/authState.dart';
import 'package:jendela_dbp/stateManagement/states/productState.dart';
import 'package:jendela_dbp/view/authentication/signin.dart';

class UserBooks extends StatefulWidget {
  const UserBooks({super.key, this.controller});
  final controller;

  @override
  State<UserBooks> createState() => _UserBooksState();
}

class _UserBooksState extends State<UserBooks> {
  final HivePurchasedBook purchasedBook = HivePurchasedBook();
  ProductBloc purchasedBookBloc = ProductBloc();
  ConnectionCubit conCubit = ConnectionCubit();
  @override
  void initState() {
    super.initState();
    purchasedBookBloc.add(
      ProductPurchasedBooksFetch(),
    );
  }

  @override
  void dispose() {
    purchasedBookBloc.close();
    super.dispose();
  }

  DbpColor colors = DbpColor();
   
  @override
  Widget build(BuildContext context) {
    AuthCubit _authCubit = BlocProvider.of<AuthCubit>(context);
    conCubit.checkConnection(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(88.0),
        child: Column(
          children: [
            AppBar(
              title: const Text('My Books'),
              centerTitle: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SmoothPageIndicator(
                  controller: widget.controller,
                  count: 2,
                  effect: ExpandingDotsEffect(
                      activeDotColor: DbpColor().jendelaOrange,
                      dotColor: DbpColor().jendelaGray,
                      dotHeight: 8,
                      dotWidth: 8),
                  onDotClicked: (index) => widget.controller.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn),
                ),
              ],
            ),
          ],
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
            if (state is AuthLoaded) {
              if (state.isAuthenticated == true) {
                return BlocConsumer<ProductBloc, ProductState>(
                  bloc: purchasedBookBloc,
                  listener: (context, state) {
                    if (state is ProductError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text(state.message ?? ''),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ProductLoaded) {
                      if ((state.dataBooks?.length ?? 0) > 0) {
                        List<Widget> listOfWidget = [];
                        state.dataBooks!.forEach((index) {
                          HivePurchasedBook? book =
                              bookPurchaseBox.get(index) ?? HivePurchasedBook();
                          listOfWidget.add(BookPurchasedCoverCard(context,
                              purchasedBook: book));
                        });
                        // return
                        return GridView(
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
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

                    return const PurchaseSignIn();
                  },
                );
              }
              return const PurchaseSignIn();
            }
            return const PurchaseSignIn();
          },
        ),
      ),
    );
  }
}
