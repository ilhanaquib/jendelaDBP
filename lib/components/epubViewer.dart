import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:text_scroll/text_scroll.dart';

class EpubViewerPage extends StatefulWidget {
  const EpubViewerPage({super.key, this.book});

  final HiveBookAPI? book;

  @override
  State<EpubViewerPage> createState() => _EpubViewerPageState();
}

class _EpubViewerPageState extends State<EpubViewerPage> {
  late EpubController _epubController;
  String? lastReadCfi; // Store the last read position
  bool isOverlayVisible = false;

  void showOverlayPage() {
    setState(() {
      isOverlayVisible = true;
    });
  }

  void closeOverlayPage() {
    setState(() {
      isOverlayVisible = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize with the saved last read position or start from the beginning
    _epubController = EpubController(
      document: EpubDocument.openAsset('assets/books/accessible_epub_3.epub'),
      epubCfi: lastReadCfi ?? 'epubcfi(/6/6[chapter-1]!/4/2/1)',
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Save the current position when the user closes the book
    lastReadCfi = _epubController.generateEpubCfi();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          // Close the overlay page if it's visible
          if (isOverlayVisible) {
            closeOverlayPage();
            return false; // Prevent default back navigation
          }
          return true; // Allow default back navigation
        },
        child: Scaffold(
          appBar: AppBar(
            title: TextScroll(
              widget.book!.name!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              mode: TextScrollMode.endless,
              velocity: const Velocity(
                pixelsPerSecond: Offset(30, 0),
              ),
              selectable: true,
              pauseBetween: const Duration(seconds: 20),
            ),
            leading: IconButton(
              onPressed: () async {
                // Close the overlay page if it's visible
                if (isOverlayVisible) {
                  closeOverlayPage();
                } else {
                  Navigator.of(context)
                      .pop(); // Navigate back to the previous page
                }
              },
              icon: const Icon(Icons.arrow_back),
            ),
            actions: [
              IconButton(
                onPressed: showOverlayPage,
                icon: const Icon(Icons.bookmark_outline_rounded),
              )
            ],
          ),
          body: Stack(children: [
            EpubView(
              controller: _epubController,
              
            ),
            if (isOverlayVisible)
              GestureDetector(
                onTap: closeOverlayPage,
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: CustomScrollView(
                      slivers: [
                        const SliverAppBar(
                          floating: true,
                          snap: true,
                          elevation: 0.0,
                          toolbarHeight: 0.01,
                        ),
                        SliverFillRemaining(
                          child: EpubViewTableOfContents(
                            controller: _epubController,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
          ]),
        ),
      );
}
