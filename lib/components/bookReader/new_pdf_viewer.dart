
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

// ignore: must_be_immutable
class NewPdfViewerPage extends StatefulWidget {
  NewPdfViewerPage({super.key, required this.pdfPath, required this.bookName});

  File pdfPath;
  String bookName;

  @override
  State<NewPdfViewerPage> createState() => _NewPdfViewerPageState();
}

class _NewPdfViewerPageState extends State<NewPdfViewerPage> {
  int lastRead = 0;
  bool showAppBar = true;

  getLastReadPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedLastRead = prefs.getInt('lastRead');

    if (storedLastRead != null) {
      // Value exists in SharedPreferences
      lastRead = storedLastRead;
    } else {
      // No value found in SharedPreferences, setting a default value of 1
      lastRead = 1;
    }

    //print('this is the last read page: $lastRead');
  }

  @override
  void initState() {
    super.initState();
    getLastReadPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: TextScroll(
                widget.bookName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                mode: TextScrollMode.endless,
                velocity: const Velocity(
                  pixelsPerSecond: Offset(30, 0),
                ),
                selectable: true,
                pauseBetween: const Duration(seconds: 20),
              ),
            )
          : null,
      body: GestureDetector(
        onTap: () {
          setState(
            () {
              showAppBar = !showAppBar;
            },
          );
        },
        child: SizedBox(
          child: PDFView(
            filePath: widget.pdfPath.path,
            swipeHorizontal: true,
            defaultPage: lastRead,
            onPageChanged: (page, total) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setInt('lastRead', page!);
            },
          ),
        ),
      ),
    );
  }
}
