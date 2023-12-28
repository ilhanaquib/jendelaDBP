import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:jendela_dbp/components/berita/berita_detail_screen.dart';
import 'package:jendela_dbp/hive/models/hive_berita_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class FirstBeritaCard extends StatefulWidget {
  const FirstBeritaCard(
      {Key? key,
      this.viewCount = 0,
      this.isSaved = false,
      this.bookmark = false,
      required this.berita,
      required this.textSize})
      : super(key: key);

  final int viewCount;
  final bool isSaved;
  final bool bookmark;
  final Berita berita;
  final double textSize;
  @override
  State<FirstBeritaCard> createState() => _FirstBeritaCard();
}

class _FirstBeritaCard extends State<FirstBeritaCard> {
  void _launchURL() async {
    if (await canLaunchUrl(
        Uri.parse(widget.berita.guid ?? "https://{GlobalVar.BaseURLDomain}"))) {
      await launchUrl(
          Uri.parse(widget.berita.guid ?? "https://{GlobalVar.BaseURLDomain}"));
    } else {
      throw 'Berita ini tidak boleh ditunjuk';
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
    if (widget.berita.featuredImage != null) {
      return Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              imageUrl: widget.berita.featuredImage!,
              fit: BoxFit.cover,
            ),
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
      return Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              'assets/images/logonobg.png',
              fit: BoxFit.cover,
            ),
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
            screen: BeritaDetailScreen(
              berita: widget.berita,
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 30, 41, 59),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: getImageWidget()),
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 8.0),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         border: Border.all(
                  //             color: DbpColor().jendelaOrange, width: 2.0),
                  //         color: DbpColor().jendelaOrange,
                  //         borderRadius: BorderRadius.circular(100)),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(4.0),
                  //       child: Text(
                  //         getCategoryName(widget.berita.domain!),
                  //         style: const TextStyle(
                  //             color: Colors.black, fontSize: 10),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: widget.textSize,
                          child: Text(
                            parse(widget.berita.postTitle).body?.text ?? '',
                            softWrap: true,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          DateFormat('d MMM yyyy, HH:mm').format(
                            DateTime.parse(widget.berita.postDate ?? ''),
                          ),
                          style: const TextStyle(
                              textBaseline: TextBaseline.alphabetic,
                              color: Color.fromARGB(255, 201, 211, 223)),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
