import 'dart:io';

import 'package:flutter/material.dart';

import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:http/http.dart' as http;

class DownloadAlertDialog extends StatefulWidget {
  final String url;
  final String path;

  const DownloadAlertDialog({super.key, required this.url, required this.path});

  @override
  _DownloadAlertDialogState createState() => _DownloadAlertDialogState();
}

class _DownloadAlertDialogState extends State<DownloadAlertDialog> {
  late double _downloadProgress = 0.0;
  late int _totalSize = 0;

  @override
  void initState() {
    super.initState();
    _downloadFile();
  }

  Future<void> _downloadFile() async {
    final request = http.Request('GET', Uri.parse(widget.url));
    final response = await http.Client().send(request);
    _totalSize = response.contentLength ?? 0;
    List<int> bytes = [];

    response.stream.listen(
      (List<int> chunk) {
        bytes.addAll(chunk);
        setState(() {
          _downloadProgress = bytes.length / _totalSize;
        });
      },
      onDone: () async {
        final file = File(widget.path);
        await file.writeAsBytes(bytes);
        // Encrypt file if needed
        // File securePath = await EncryptFile.encryptFile(file);
        Navigator.of(context).pop();
      },
      onError: (e) {
        // Handle error during download
        //print('Download Error: $e');
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      backgroundColor: Colors.white,
      title: const Text('Sedang dimuat turun...'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: _downloadProgress,
            color: DbpColor().jendelaOrange,
          ),
          const SizedBox(height: 10),
          Text(
            '${(_downloadProgress * 100).toStringAsFixed(2)}%',
          ),
          const SizedBox(height: 5),
          Text(
            'Saiz: ${(_totalSize / (1024 * 1024)).toStringAsFixed(2)} MB',
          ),
        ],
      ),
    );
  }
}
