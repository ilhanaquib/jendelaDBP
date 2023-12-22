import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/parser.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/hive/models/hive_berita_model.dart';
import 'package:jendela_dbp/stateManagement/blocs/berita_bloc.dart';
import 'package:jendela_dbp/stateManagement/cubits/auth_cubit.dart';
import 'package:jendela_dbp/stateManagement/events/berita_event.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BeritaDetailScreen extends StatefulWidget {
  const BeritaDetailScreen({Key? key, this.berita}) : super(key: key);

  final Berita? berita;

  @override
  // ignore: library_private_types_in_public_api
  _BeritaDetailScreen createState() => _BeritaDetailScreen();
}

class _BeritaDetailScreen extends State<BeritaDetailScreen> {
  BeritaBloc relatedBeritaBloc = BeritaBloc();
  late AuthCubit _authCubit;

  @override
  void initState() {
    relatedBeritaBloc.add(BeritaFetch());
    super.initState();
  }

  @override
  void dispose() {
    relatedBeritaBloc.close();
    _authCubit.setHideNavigationBar(hideNavBar: false);
    super.dispose();
  }

  DbpColor colors = DbpColor();
  @override
  Widget build(BuildContext context) {
    _authCubit = BlocProvider.of<AuthCubit>(context);
    _authCubit.setHideNavigationBar(hideNavBar: true);
    Uri uri =
        Uri.parse(widget.berita!.guid ?? "https://{GlobalVar.BaseURLDomain}");
    Map<String, dynamic> queryParam = uri.queryParameters
        .map((key, value) => MapEntry(key, value.toString()));
    queryParam.addAll({'_fromApp': 'y'});
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(uri);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            parse(widget.berita?.postTitle).body?.text ?? '',
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
        body: WebViewWidget(
          controller: controller,
        ),
      ),
    );
    // return ScreenBoilerPlate(
    //   enableSearch: false,
    //   title: Text(
    //     widget.berita!.postTitle ?? '',
    //     textAlign: TextAlign.center,
    //     overflow: TextOverflow.ellipsis,
    //     maxLines: 2,
    //     style: TextStyle(
    //       fontSize: size.width * 0.06,
    //       color: Colors.black.withOpacity(0.7),
    //       fontWeight: FontWeight.bold,
    //     ),
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
    //                   child: widget.berita!.featuredImage == null
    //                       ? SizedBox(
    //                           // width: 200,
    //                           height: 100,
    //                         )
    //                       : Image.network(
    //                           widget.berita!.featuredImage ?? '',
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
    //                 parse(widget.berita?.postTitle).body?.text ?? '',
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
    //                   widget.berita!.postDate ?? '',
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
    //                 parse(widget.berita!.postContent).body!.text,
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
    //                     MaterialPageRoute(builder: (context) => NewsScreen()),
    //                   );
    //                 },
    //               ),
    //               Container(
    //                 height: 200,
    //                 child: BlocBuilder<BeritaBloc, BeritaState>(
    //                   bloc: relatedBeritaBloc,
    //                   builder: (context, data) {
    //                     if (data is BeritaLoaded) {
    //                       List<Widget> listWidget =
    //                           data.listOfBerita!.map<Widget>(
    //                         (item) {
    //                           return DBPEaseInAnimation(
    //                             child: Container(
    //                               width: 350,
    //                               height: 200,
    //                               child: BeritaCard(
    //                                 berita: item,
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
