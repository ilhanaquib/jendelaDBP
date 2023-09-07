import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:jendela_dbp/hive/models/hivePostModel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PostCard extends StatefulWidget {
  PostCard({
    Key? key,
    this.mediaHeight = 100.0,
    this.mediaWidth = 400.0,
    required this.post,
  }) : super(key: key);

  final Post post;
  final double mediaHeight;
  final double mediaWidth;
  @override
  _PostCard createState() => _PostCard();
}

class _PostCard extends State<PostCard> {
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
    return Container(
      child: GestureDetector(
        // onTap: () async {
        //   var postLink = Uri.parse(widget.post.link!);
        //   setState(() {
        //     launchUrl(postLink, mode: LaunchMode.inAppWebView);
        //   });
        // },
        child: Stack(
          children: [
            SizedBox(
              width: widget.mediaWidth,
              // height: 200,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      child: Text(
                        parse(widget.post.title).documentElement?.text ?? '',
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    HtmlWidget(widget.post.content!),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        DateFormat('d MMM yyyy')
                            .format(DateTime.parse(widget.post.date ?? '')),
                        style: const TextStyle(
                            textBaseline: TextBaseline.alphabetic, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              thickness: 2,
              color: Colors.black,
              indent: 12,
              endIndent: 12,
            )
          ],
        ),
      ),
    );
  }

  Widget getImage() {
    late Widget theWidget;
    if (widget.post.featured_media_urls != null) {
      theWidget = CachedNetworkImage(
        width: widget.mediaWidth,
        height: widget.mediaHeight,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
        imageUrl: widget.post.featured_media_urls ?? '',
        progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
          child: Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: const Color.fromARGB(255, 123, 123, 123),
              secondRingColor: const Color.fromARGB(255, 144, 191, 63),
              thirdRingColor: const Color.fromARGB(255, 235, 127, 35),
              size: 30.0,
            ),
          ),
        ),
      );
    } else if (widget.post.featured_media_urls != null) {
      theWidget = CachedNetworkImage(
        width: widget.mediaWidth,
        height: widget.mediaHeight,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
        imageUrl: widget.post.featured_media_urls ?? '',
        progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
          child: Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: const Color.fromARGB(255, 123, 123, 123),
              secondRingColor: const Color.fromARGB(255, 144, 191, 63),
              thirdRingColor: const Color.fromARGB(255, 235, 127, 35),
              size: 50.0,
            ),
          ),
        ),
      );
    } else {
      theWidget =
          SizedBox(width: widget.mediaWidth, height: widget.mediaHeight);
    }
    return theWidget;
  }
}
