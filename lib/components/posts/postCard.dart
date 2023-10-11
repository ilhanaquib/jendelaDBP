import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:jendela_dbp/hive/models/hivePostModel.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';

class PostCard extends StatefulWidget {
  const PostCard({
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
    return SizedBox(
      child: Stack(
        children: [
          SizedBox(
            width: widget.mediaWidth,
            // height: 200,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                  HtmlWidget(
                    widget.post.content!,
                    onTapUrl: (url) => launchUrl(Uri.parse(url),
                        mode: LaunchMode.inAppWebView),
                    textStyle: const TextStyle(fontSize: 16),
                    customStylesBuilder: ((element) {
                      if (element.classes.contains('wp-caption-text')) {
                        return {'color': 'gray', 'font-size': 'smaller'};
                      }
                      if (element.classes.contains('statement')) {
                        return {'color': 'gray', 'font-size': 'smaller'};
                      }
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      DateFormat('d MMM yyyy')
                          .format(DateTime.parse(widget.post.date ?? '')),
                      style: const TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 2,
            color: Colors.grey,
            indent: 12,
            endIndent: 12,
          )
        ],
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
              color: DbpColor().jendelaGray,
              secondRingColor: DbpColor().jendelaGreen,
              thirdRingColor: DbpColor().jendelaOrange,
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
              color: DbpColor().jendelaGray,
              secondRingColor: DbpColor().jendelaGreen,
              thirdRingColor: DbpColor().jendelaOrange,
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
