import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:jendela_dbp/controllers/screen_size.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/hive/models/hive_article_model.dart';
import 'package:jendela_dbp/view/pages/articles/article_detail_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class ArticleSlideshowCard extends StatefulWidget {
  const ArticleSlideshowCard(
      {Key? key,
      this.viewCount = 0,
      this.isSaved = false,
      this.bookmark = false,
      required this.article,
      required this.textSize,
      required this.pageContoller})
      : super(key: key);

  final int viewCount;
  final bool isSaved;
  final bool bookmark;
  final Article article;
  final double textSize;
  final PageController pageContoller;
  @override
  State<ArticleSlideshowCard> createState() => _HomeArticleCard();
}

class _HomeArticleCard extends State<ArticleSlideshowCard> {
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

  Widget getImageWidget() {
    if (widget.article.featuredImage != null) {
      return Stack(
        children: [
          CachedNetworkImage(
            imageUrl: widget.article.featuredImage!,
            width: ResponsiveLayout.isDesktop(context)
                ? 1200
                : ResponsiveLayout.isTablet(context)
                    ? 850
                    : 500,
            height: 500,
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(1)],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // Display a default image from assets if featuredImage is null
      return Stack(
        children: [
          Image.asset(
            'assets/images/logonobg.png', // Replace 'default_image.png' with your actual default image path
            width: ResponsiveLayout.isDesktop(context)
                ? 1200
                : ResponsiveLayout.isTablet(context)
                    ? 850
                    : 500,
            height: 500,
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(1)],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),
        ],
      );
    }
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
          getImageWidget(),
          Positioned(
            bottom: 10,
            left: 10,
            child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 0, bottom: 24),
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
          ),
          Positioned(
            bottom: 10,
            left: 135,
            child: SmoothPageIndicator(
              controller: widget.pageContoller,
              count: 8,
              effect: ExpandingDotsEffect(
                  activeDotColor: DbpColor().jendelaOrange,
                  dotColor: DbpColor().jendelaGray,
                  dotHeight: 8,
                  dotWidth: 8),
              onDotClicked: (index) => widget.pageContoller.animateToPage(index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn),
            ),
          ),
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
