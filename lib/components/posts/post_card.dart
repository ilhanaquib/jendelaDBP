// ignore: file_names
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/controllers/screen_size.dart';
import 'package:jendela_dbp/view/pages/postAndArticles/posts/read_post.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:jendela_dbp/hive/models/hive_post_model.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

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
  State<PostCard> createState() => _PostCard();
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
    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          withNavBar: false,
          screen: ReadPost(post: widget.post),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: DbpColor().jendelaGreen,
            ),
          ),
          color: Colors.white,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: widget.post.featuredMediaUrls!,
                    width: ResponsiveLayout.isDesktop(context)
                        ? 200
                        : ResponsiveLayout.isTablet(context)
                            ? 170
                            : 120,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        widget.post.title!,
                        maxLines: 4,
                        softWrap: true,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      DateFormat('d MMM yyyy')
                          .format(DateTime.parse(widget.post.date ?? '')),
                      style: const TextStyle(
                        textBaseline: TextBaseline.alphabetic,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getImage() {
    late Widget theWidget;
    if (widget.post.featuredMediaUrls != null) {
      theWidget = CachedNetworkImage(
        width: widget.mediaWidth,
        height: widget.mediaHeight,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
        imageUrl: widget.post.featuredMediaUrls ?? '',
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
    } else if (widget.post.featuredMediaUrls != null) {
      theWidget = CachedNetworkImage(
        width: widget.mediaWidth,
        height: widget.mediaHeight,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
        imageUrl: widget.post.featuredMediaUrls ?? '',
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
