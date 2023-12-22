import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:jendela_dbp/components/berita/berita_detail_screen.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/hive/models/hive_berita_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class BeritaCard extends StatefulWidget {
  const BeritaCard(
      {Key? key,
      this.viewCount = 0,
      this.isSaved = false,
      this.bookmark = false,
      required this.berita})
      : super(key: key);

  final int viewCount;
  final bool isSaved;
  final bool bookmark;
  final Berita berita;
  @override
  State<BeritaCard> createState() => _ArticleCard();
}

class _ArticleCard extends State<BeritaCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          withNavBar: false,
          screen: BeritaDetailScreen(
            berita: widget.berita,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 8.0),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       border:
            //           Border.all(color: DbpColor().jendelaTurqoise, width: 2.0),
            //       color: DbpColor().jendelaTurqoise,
            //       borderRadius: BorderRadius.circular(100),
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.only(left: 8, right: 8),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: widget.berita.categories!.map((category) {
            //           // Assuming 'name' is a key in the category object
            //           String categoryName = category[
            //               'name']; // Replace 'name' with the actual key name
            //           return Text(
            //             categoryName,
            //             style: const TextStyle(
            //                 color: Colors.white,
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 13),
            //           );
            //         }).toList(),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8, right: 10, top: 10, bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: widget.berita.featuredImage!,
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
                  SizedBox(
                    width: 150,
                    child: Text(
                      parse(widget.berita.postTitle).body?.text ?? '',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    DateFormat('d MMM yyyy')
                        .format(DateTime.parse(widget.berita.postDate ?? '')),
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
    if (widget.berita.featuredImage2 != null) {
      theWidget = CachedNetworkImage(
        width: 150,
        alignment: Alignment.bottomCenter,
        fit: BoxFit.fitHeight,
        imageUrl: widget.berita.featuredImage2 ?? '',
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
    } else if (widget.berita.featuredImage != null) {
      theWidget = CachedNetworkImage(
        width: 150,
        alignment: Alignment.bottomCenter,
        fit: BoxFit.fitHeight,
        imageUrl: widget.berita.featuredImage ?? '',
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
