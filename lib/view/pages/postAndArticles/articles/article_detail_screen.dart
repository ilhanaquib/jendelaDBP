
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/parser.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/hive/models/hiveArticleModel.dart';
import 'package:jendela_dbp/stateManagement/blocs/article_bloc.dart';
import 'package:jendela_dbp/stateManagement/cubits/auth_cubit.dart';
import 'package:jendela_dbp/stateManagement/events/article_event.dart';

class ArticleDetailScreen extends StatefulWidget {
  const ArticleDetailScreen({Key? key, this.article}) : super(key: key);

  final Article? article;

  @override
  // ignore: library_private_types_in_public_api
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
        body: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}
