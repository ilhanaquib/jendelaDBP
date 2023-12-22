// ignore: file_names
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/view/pages/posts/read_post.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:jendela_dbp/hive/models/hive_post_model.dart';

class HomePostCard extends StatefulWidget {
  const HomePostCard({
    Key? key,
    this.mediaHeight = 100.0,
    this.mediaWidth = 400.0,
    required this.post,
  }) : super(key: key);

  final Post post;
  final double mediaHeight;
  final double mediaWidth;
  @override
  State<HomePostCard> createState() => _HomePostCard();
}

class _HomePostCard extends State<HomePostCard> {
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: widget.post.featuredMediaUrls!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Text(
                    widget.post.title!,
                    softWrap: true,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    DateFormat('d MMM yyyy HH:mm').format(
                      DateTime.parse(widget.post.date ?? ''),
                    ),
                    style: const TextStyle(
                      textBaseline: TextBaseline.alphabetic,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
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
