import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:jendela_dbp/hive/models/hivePostModel.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:url_launcher/url_launcher.dart';

class readPost extends StatefulWidget {
  const readPost({super.key, required this.post});

  final Post post;

  @override
  State<readPost> createState() => _readPostState();
}

class _readPostState extends State<readPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextScroll(
          widget.post.title!,
          mode: TextScrollMode.bouncing,
          velocity: const Velocity(
            pixelsPerSecond: Offset(50, 0),
          ),
          selectable: true,
          pauseBetween: const Duration(seconds: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                  onTapUrl: (url) =>
                      launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView),
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
      ),
    );
  }
}
