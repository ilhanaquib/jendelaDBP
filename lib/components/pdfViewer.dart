import 'package:flutter/material.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';
import 'package:jendela_dbp/hive/models/hiveBookModel.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_scroll/text_scroll.dart';

class PdfViewerPage extends StatefulWidget {
  const PdfViewerPage({super.key, this.book});

  final HiveBookAPI? book;

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  int? lastRead = 0;
  final PdfViewerController _pdfViewerController = PdfViewerController();
  bool showAppBar = true;

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
                widget.book!.name!,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                )
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
          child: SfPdfViewer.network(
            'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
            key: _pdfViewerKey,
            scrollDirection: PdfScrollDirection.horizontal,
            enableTextSelection: true,
            pageLayoutMode: PdfPageLayoutMode.single,
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
              _pdfViewerController.jumpToPage(lastRead!);
            },
          ),
        ),
      ),
    );
  }
}
