import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/hive/models/hive_article_model.dart';
import 'package:jendela_dbp/view/pages/articles/article_detail_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class ArticleCard extends StatefulWidget {
  const ArticleCard(
      {Key? key,
      this.viewCount = 0,
      this.isSaved = false,
      this.bookmark = false,
      required this.article})
      : super(key: key);

  final int viewCount;
  final bool isSaved;
  final bool bookmark;
  final Article article;
  @override
  State<ArticleCard> createState() => _ArticleCard();
}

class _ArticleCard extends State<ArticleCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          withNavBar: false,
          screen: ArticleDetailScreen(
            article: widget.article,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 8),
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: DbpColor().jendelaTurqoise, width: 2.0),
                  color: DbpColor().jendelaTurqoise,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.article.categories!.map((category) {
                      // Assuming 'name' is a key in the category object
                      String categoryName = category[
                          'name']; // Replace 'name' with the actual key name
                      return Text(
                        categoryName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8, right: 10, top: 10, bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: widget.article.featuredImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    parse(widget.article.postTitle).body?.text ?? '',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    DateFormat('d MMM yyyy, HH:mm')
                        .format(DateTime.parse(widget.article.postDate ?? '')),
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
