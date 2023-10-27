import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:html/parser.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';
import 'package:jendela_dbp/hive/models/hiveArticleModel.dart';
import 'package:jendela_dbp/stateManagement/blocs/articleBloc.dart';
import 'package:jendela_dbp/stateManagement/cubits/AuthCubit.dart';
import 'package:jendela_dbp/stateManagement/events/articleEvent.dart';

class ArticleDetailScreen extends StatefulWidget {
  ArticleDetailScreen({Key? key, this.article}) : super(key: key);

  final Article? article;

  @override
  _ArticleDetailScreen createState() => _ArticleDetailScreen();
}

class _ArticleDetailScreen extends State<ArticleDetailScreen> {
  ArticleBloc relatedArticleBloc = ArticleBloc();
  late AuthCubit _authCubit;

  @override
  void initState() {
    relatedArticleBloc.add(ArticleFetch());
    super.initState();
  }

  @override
  void dispose() {
    relatedArticleBloc.close();
    _authCubit.setHideNavigationBar(hideNavBar: false);
    super.dispose();
  }

  DbpColor colors = DbpColor();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context)!.size;
    _authCubit = BlocProvider.of<AuthCubit>(context);
    _authCubit.setHideNavigationBar(hideNavBar: true);
    Uri uri =
        Uri.parse(widget.article!.guid ?? "https://{GlobalVar.BaseURLDomain}");
    Map<String, dynamic> queryParam = uri.queryParameters.map(
      (key, value) => MapEntry(
        key,
        value.toString(),
      ),
    );
    queryParam.addAll({'_fromApp': 'y'});
    return SafeArea(
      child: WebviewScaffold(
        url: Uri.parse(uri.origin)
            .replace(queryParameters: queryParam)
            .toString(),
        supportMultipleWindows: true,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            parse(widget.article?.postTitle).body?.text ?? '',
            // textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black.withOpacity(0.7),
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: colors.bgPrimaryColor,
        ),
        withJavascript: true,
      ),
    );
    // return ScreenBoilerPlate(
    //   enableSearch: false,
    //   title: Text(
    //     parse(widget.artikel?.postTitle).body?.text ?? '',
    //     textWidthBasis: TextWidthBasis.parent,
    //     overflow: TextOverflow.ellipsis,
    //     maxLines: 2,
    //     textAlign: TextAlign.center,
    //     style: TextStyle(
    //         color: colors.textPrimaryColor,
    //         fontSize: 20.0,
    //         fontWeight: FontWeight.w600),
    //   ),
    //   child: SingleChildScrollView(
    //       physics: BouncingScrollPhysics(),
    //       child: Container(
    //         width: size.width,
    //         child: Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Column(
    //             children: [
    //               Container(
    //                 decoration: BoxDecoration(boxShadow: [
    //                   BoxShadow(
    //                     color: Colors.grey.withOpacity(0.5),
    //                     spreadRadius: 0.3,
    //                     blurRadius: 7,
    //                     offset: Offset(5, 5), // changes position of shadow
    //                   ),
    //                 ]),
    //                 width: size.width,
    //                 height: 200,
    //                 child: ClipRRect(
    //                   borderRadius: BorderRadius.circular(5.0),
    //                   child: widget.artikel!.featuredImage == null
    //                       ? SizedBox(
    //                           // width: 200,
    //                           height: 100,
    //                         )
    //                       : Image.network(
    //                           widget.artikel!.featuredImage ?? '',
    //                           // width: 200.0,
    //                           height: 100,
    //                           fit: BoxFit.cover,
    //                         ),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 10.0,
    //               ),
    //               Text(
    //                 parse(widget.artikel?.postTitle).body?.text ?? '',
    //                 textWidthBasis: TextWidthBasis.parent,
    //                 textAlign: TextAlign.left,
    //                 style: TextStyle(
    //                     color: colors.textPrimaryColor,
    //                     fontSize: 30.0,
    //                     fontWeight: FontWeight.w600),
    //               ),
    //               SizedBox(
    //                 height: 10.0,
    //               ),
    //               SizedBox(
    //                 width: size.width,
    //                 child: Text(
    //                   widget.artikel!.postDate ?? '',
    //                   textAlign: TextAlign.start,
    //                   style: TextStyle(
    //                       color: colors.textPrimaryColor,
    //                       fontSize: 16.0,
    //                       fontWeight: FontWeight.bold),
    //                 ),
    //               ),
    //               Divider(
    //                 color: colors.btnPrimaryColor,
    //                 thickness: 0.2,
    //                 height: 10,
    //               ),
    //               SizedBox(height: 10.0),
    //               Text(
    //                 parse(widget.artikel!.postContent).body!.text,
    //                 textAlign: TextAlign.left,
    //                 style: TextStyle(
    //                     color: colors.textPrimaryColor,
    //                     fontSize: 20.0,
    //                     wordSpacing: 5,
    //                     height: 1.5,
    //                     fontWeight: FontWeight.w400),
    //               ),
    //               Divider(
    //                 color: colors.btnPrimaryColor,
    //                 thickness: 0.2,
    //                 height: 10,
    //               ),
    //               SizedBox(height: 10.0),
    //               CarouselTitle(
    //                 title: 'Lagi Menarik',
    //                 seeAllText: "Lihat Semua",
    //                 seeAllOnTap: () {
    //                   Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                         builder: (context) => ArtikelScreen()),
    //                   );
    //                 },
    //               ),
    //               Container(
    //                 height: 200,
    //                 child: BlocBuilder<ArtikelBloc, ArtikelState>(
    //                   bloc: relatedArtikelBloc,
    //                   builder: (context, data) {
    //                     if (data is ArtikelLoaded) {
    //                       List<Widget> listWidget =
    //                           data.listOfArtikel!.map<Widget>(
    //                         (item) {
    //                           return DBPEaseInAnimation(
    //                             child: Container(
    //                               width: 350,
    //                               height: 200,
    //                               child: ArtikelCard(
    //                                 artikel: item,
    //                                 isSaved: false,
    //                                 bookmark: false,
    //                                 viewCount: 212,
    //                               ),
    //                             ),
    //                           );
    //                         },
    //                       ).toList();
    //                       if (listWidget.length == 0) {
    //                         return Center(
    //                           child: Text('Maaf, pautan tidak dijumpai.'),
    //                         );
    //                       }
    //                       return ListView(
    //                         physics: BouncingScrollPhysics(),
    //                         scrollDirection: Axis.horizontal,
    //                         children: listWidget,
    //                       );
    //                     }
    //                     return SpinKitDoubleBounce(
    //                       color: colors.textPrimaryColor,
    //                       size: 50.0,
    //                     );
    //                   },
    //                 ),
    //               ),
    //               SizedBox(height: 10.0),
    //             ],
    //           ),
    //         ),
    //       )),
    //   // floatingActionButton: FloatingActionButton(
    //   //   backgroundColor: colors.bgPrimaryColor,
    //   //   onPressed: () {},
    //   //   tooltip: 'Kongsi',
    //   //   child: Icon(
    //   //     CupertinoIcons.share,
    //   //     color: colors.textPrimaryColor,
    //   //   ),
    //   // ),
    // );
  }
}
