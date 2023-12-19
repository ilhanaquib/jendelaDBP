
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/hive/models/hive_post_model.dart';
import 'package:jendela_dbp/stateManagement/blocs/post_bloc.dart';
import 'package:jendela_dbp/stateManagement/events/post_event.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/parser.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/stateManagement/cubits/auth_cubit.dart';

class ReadPost extends StatefulWidget {
  const ReadPost({Key? key, this.post}) : super(key: key);

  final Post? post;

  @override
  State<ReadPost> createState() => _ArticleDetailScreen();
}

class _ArticleDetailScreen extends State<ReadPost> {
  PostBloc relatedPostBloc = PostBloc();
  late AuthCubit _authCubit;

  @override
  void initState() {
    relatedPostBloc.add(PostFetch());
    super.initState();
  }

  @override
  void dispose() {
    relatedPostBloc.close();
    _authCubit.setHideNavigationBar(hideNavBar: false);
    super.dispose();
  }

  DbpColor colors = DbpColor();
  @override
  Widget build(BuildContext context) {
    _authCubit = BlocProvider.of<AuthCubit>(context);
    _authCubit.setHideNavigationBar(hideNavBar: true);
    Uri uri =
        Uri.parse(widget.post!.link ?? "https://{GlobalVar.BaseURLDomain}");
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
            parse(widget.post?.title).body?.text ?? '',
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
