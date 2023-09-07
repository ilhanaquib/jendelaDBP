import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:jendela_dbp/hive/models/hivePostModel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class PostCard extends StatefulWidget {
  PostCard({
    Key? key,
    this.mediaHeight = 100.0,
    this.mediaWidth = 200.0,
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
    Size? size = MediaQuery.maybeOf(context)!.size;
    return Container(
      child: GestureDetector(
        onTap: () async {
          var postLink = Uri.parse(widget.post.link!);
          setState(() {
            launchUrl(postLink, mode: LaunchMode.inAppWebView);
          });
        },
        child: Stack(
          children: [
            Container(
              width: widget.mediaWidth,
              // height: 200,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0.3,
                            blurRadius: 7,
                            offset: Offset(5, 5), // changes position of shadow
                          ),
                        ]),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: getImage()),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        parse(widget.post.title).documentElement?.text ?? '',
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        DateFormat('d MMM yyyy')
                            .format(DateTime.parse(widget.post.date ?? '')),
                        style: const TextStyle(
                            textBaseline: TextBaseline.alphabetic),
                      ),
                    ],
                  )),
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
