import 'dart:io';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:text_scroll/text_scroll.dart';

// ignore: must_be_immutable
class PdfViewerPage extends StatefulWidget {
  PdfViewerPage({super.key, required this.pdfPath, required this.bookName});

  File pdfPath;
  String bookName;

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  int? lastRead = 0;
  final PdfViewerController _pdfViewerController = PdfViewerController();
  PdfTextSearchResult _searchResult = PdfTextSearchResult();
  final TextEditingController _searchController = TextEditingController();

  bool showAppBar = true;

  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search PDF'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Enter search query',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String searchQuery = _searchController.text;
                if (searchQuery.isNotEmpty) {
                  _searchResult = _pdfViewerController.searchText(searchQuery,
                      searchOption: TextSearchOption.caseSensitive);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Search'),
            ),
            IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_up,
                color: Colors.black,
              ),
              onPressed: () {
                _searchResult.previousInstance();
                setState(() {}); // Update the UI to reflect the new instance
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
              ),
              onPressed: () {
                _searchResult.nextInstance();
                setState(() {}); // Update the UI to reflect the new instance
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: TextScroll(
                widget.bookName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                mode: TextScrollMode.endless,
                velocity: const Velocity(
                  pixelsPerSecond: Offset(30, 0),
                ),
                selectable: true,
                pauseBetween: const Duration(seconds: 20),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    _pdfViewerKey.currentState?.openBookmarkView();
                  },
                  icon: const Icon(Icons.bookmark_outline_rounded),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    showSearchDialog(context);
                  },
                ),
              ],
            )
          : null,
      body: GestureDetector(
        onTap: () {
          setState(() {
            showAppBar = !showAppBar;
          });
        },
        child: SizedBox(
          child: SfPdfViewer.file(
            widget.pdfPath,
            key: _pdfViewerKey,
            scrollDirection: PdfScrollDirection.horizontal,
            enableTextSelection: true,
            pageLayoutMode: PdfPageLayoutMode.continuous,
            canShowScrollHead: true,
            canShowScrollStatus: true,
            onPageChanged: (PdfPageChangedDetails details) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setInt('lastRead', details.newPageNumber);
            },
            controller: _pdfViewerController,
            onDocumentLoaded: (details) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              lastRead = prefs.getInt('lastRead');
              if (lastRead != null) {
                _pdfViewerController.jumpToPage(lastRead!);
              } else {
                _pdfViewerController.jumpToPage(1);
              }
            },
          ),
        ),
      ),
    );
  }
}
