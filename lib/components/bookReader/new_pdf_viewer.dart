import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jendela_dbp/components/bookReader/custom_linear_bar.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:material_symbols_icons/symbols.dart';
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
  late Future<int> lastRead;
  int totalPages = 0;
  int currentPage = 0;
  bool showAppBar = true;
  late PDFViewController pdfController;

  Future<int> getLastReadPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedLastRead = prefs.getInt('lastRead');

    if (storedLastRead != null) {
      return storedLastRead;
    } else {
      return 0;
    }
  }

  CustomLinearProgressBar buildProgressBar(double value) {
    return CustomLinearProgressBar(
      value: value,
      onTap: (percentage) {
        int page = (percentage * totalPages).toInt();

        pdfController.setPage(page);
      },
    );
  }

  void jumpToPage(BuildContext context) {
    int pageNumber = 1;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          title: const Text('Lompat ke muka surat'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Muka Surat'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  pageNumber = int.tryParse(value) ?? 1;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      side: BorderSide(color: DbpColor().jendelaGreen),
                      backgroundColor: DbpColor().jendelaGreen,
                      elevation: 0),
                  onPressed: () {
                    pdfController.setPage(pageNumber - 1);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Lompat',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    lastRead = getLastReadPage();
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
              actions: [
                IconButton(
                  onPressed: () {
                    jumpToPage(context);
                  },
                  icon: const Icon(Symbols.double_arrow_rounded),
                )
              ],
            )
          : null,
      body: Stack(
        children: [
          FutureBuilder<int>(
            future: lastRead,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingAnimationWidget.discreteCircle(
                  color: DbpColor().jendelaGray,
                  secondRingColor: DbpColor().jendelaGreen,
                  thirdRingColor: DbpColor().jendelaOrange,
                  size: 50.0,
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                int lastRead = snapshot.data ?? 0;
                return PDFView(
                  filePath: widget.pdfPath.path,
                  swipeHorizontal: true,
                  defaultPage: lastRead,
                  onRender: (pages) => setState(() {
                    totalPages = pages!;
                  }),
                  onViewCreated: (controller) {
                    setState(() {
                      pdfController = controller;
                    });
                  },
                  onPageChanged: (page, total) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setInt('lastRead', page!);
                    setState(() {
                      currentPage = page;
                    });
                  },
                );
              }
            },
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                showAppBar = !showAppBar;
              });
            },
          ),
          showAppBar
              ? buildProgressBar(currentPage / totalPages)
              : const SizedBox(),
          showAppBar
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text('${currentPage + 1} / $totalPages'),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
