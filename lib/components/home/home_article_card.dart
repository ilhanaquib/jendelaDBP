import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/hive/models/hive_article_model.dart';
import 'package:jendela_dbp/view/pages/postAndArticles/articles/article_detail_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomeArticleCard extends StatefulWidget {
  const HomeArticleCard(
      {Key? key,
      this.viewCount = 0,
      this.isSaved = false,
      this.bookmark = false,
      required this.article,
      required this.textSize})
      : super(key: key);

  final int viewCount;
  final bool isSaved;
  final bool bookmark;
  final Article article;
  final double textSize;
  @override
  State<HomeArticleCard> createState() => _HomeArticleCard();
}

class _HomeArticleCard extends State<HomeArticleCard> {
  void _launchURL() async {
    if (await canLaunchUrl(Uri.parse(
        widget.article.guid ?? "https://{GlobalVar.BaseURLDomain}"))) {
      await launchUrl(Uri.parse(
          widget.article.guid ?? "https://{GlobalVar.BaseURLDomain}"));
    } else {
      throw 'Could not show this article';
    }
  }

  String getCategoryName(String domain) {
    List<String> parts = domain.split('.');
    if (parts.length >= 3) {
      String firstPart = parts[0];
      String modifiedFirstPart =
          '${firstPart.substring(0, 5)} ${firstPart.substring(5)}';
      return modifiedFirstPart[0].toUpperCase() +
          modifiedFirstPart.toUpperCase().substring(1);
    }
    return domain;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Platform.isWindows) {
          _launchURL();
        } else {
          PersistentNavBarNavigator.pushNewScreen(
            context,
            withNavBar: false,
            screen: ArticleDetailScreen(
              article: widget.article,
            ),
          );
        }
      },
      child: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 1 / 1  , //21
                      child: CachedNetworkImage(
                        imageUrl: widget.article.featuredImage!,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(1)
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: DbpColor().jendelaOrange, width: 2.0),
                          color: DbpColor().jendelaOrange,
                          borderRadius: BorderRadius.circular(100)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          getCategoryName(widget.article.domain!),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    //width: 100,
                    child: SizedBox(
                      width: widget.textSize,
                      child: Text(
                        parse(widget.article.postTitle).body?.text ?? '',
                        softWrap: true,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            backgroundColor: Colors.black),
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('d MMM yyyy HH:mm').format(
                      DateTime.parse(widget.article.postDate ?? ''),
                    ),
                    style: const TextStyle(
                        textBaseline: TextBaseline.alphabetic,
                        color: Color.fromARGB(255, 201, 211, 223)),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getImage() {
    late Widget theWidget;
    if (widget.article.featuredImage2 != null) {
      theWidget = CachedNetworkImage(
        width: 150,
        alignment: Alignment.bottomCenter,
        fit: BoxFit.fitHeight,
        imageUrl: widget.article.featuredImage2 ?? '',
        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
          // alignment: Alignment.center,
          child: LoadingAnimationWidget.discreteCircle(
            color: DbpColor().jendelaGray,
            secondRingColor: DbpColor().jendelaGreen,
            thirdRingColor: DbpColor().jendelaOrange,
            size: 50.0,
          ),
        ),
      );
    } else if (widget.article.featuredImage != null) {
      theWidget = CachedNetworkImage(
        width: 150,
        alignment: Alignment.bottomCenter,
        fit: BoxFit.fitHeight,
        imageUrl: widget.article.featuredImage ?? '',
        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
          // alignment: Alignment.center,
          child: LoadingAnimationWidget.discreteCircle(
            color: DbpColor().jendelaGray,
            secondRingColor: DbpColor().jendelaGreen,
            thirdRingColor: DbpColor().jendelaOrange,
            size: 50.0,
          ),
        ),
      );
    } else {
      theWidget = const SizedBox();
    }
    return theWidget;
  }
}
