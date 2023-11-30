import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:jendela_dbp/components/bukuDibeli/bookInformation.dart';
import 'package:jendela_dbp/hive/models/hivePurchasedBookModel.dart';
import 'package:jendela_dbp/stateManagement/blocs/poductBloc.dart';

class BookPurchasedCoverCard extends StatefulWidget {
  BookPurchasedCoverCard(
    this.context, {
    Key? key,
    required this.purchasedBook,
  }) : super(key: key);
  final HivePurchasedBook purchasedBook;
  final BuildContext context;
  @override
  _BookPurchasedCoverCard createState() => _BookPurchasedCoverCard();
}

class _BookPurchasedCoverCard extends State<BookPurchasedCoverCard> {
  ProductBloc productBloc = ProductBloc();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BookInformation(bookIdentification: widget.purchasedBook),
            ),
          );
        },
        child: widget.purchasedBook.featured_media_url == null
            ? Container(decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: Image.asset('assets/images/tiadakulitbuku.png'))
            : CachedNetworkImage(
                alignment: Alignment.bottomCenter,
                fit: BoxFit.fitWidth,
                imageUrl: widget.purchasedBook.featured_media_url ?? '',
              ),
      ),
    );
  }
}
