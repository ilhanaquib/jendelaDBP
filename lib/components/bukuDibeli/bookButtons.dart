import 'package:flutter/material.dart';

Widget BukaPDFButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 40,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.red, width: 1)),
        child: Image.asset("assets/icon/pdf.png"),
      ),
      // SizedBox(
      //   width: 5,
      // ),
      // Text('Buka Pdf')
    ],
  );
}

Widget BukaAudioButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 40,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.red, width: 1)),
        child: Image.asset("assets/icon/mp3.png"),
      ),
      // SizedBox(
      //   width: 5,
      // ),
      // Text('Buka Pdf')
    ],
  );
}

Widget DownloadPDFButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 40,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.red, width: 1)),
        child: Image.asset("assets/icon/pdf-download.png"),
      ),
      // SizedBox(
      //   width: 5,
      // ),
      // Text('Pdf')
    ],
  );
}

Widget DownloadAudioButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 40,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.red, width: 1)),
        child: Image.asset("assets/icon/mp3-download.png"),
      ),
      // SizedBox(
      //   width: 5,
      // ),
      // Text('Pdf')
    ],
  );
}

Widget AudioButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 40,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.red, width: 1)),
        child: Image.asset("assets/icon/mp3.png"),
      ),
      // SizedBox(
      //   width: 5,
      // ),
      // Text('Pdf')
    ],
  );
}

Widget BukaEPUBButton() {
  return Container(
      width: 80,
      child:
          Center(child: ElevatedButton(child: Text('Baca'), onPressed: () {})));
}

Widget DownloadEPUBButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 40,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.green, width: 1)),
        child: Image.asset("assets/icon/epub-download.png"),
      ),
      // SizedBox(
      //   width: 5,
      // ),
      // Text('Epub')
    ],
  );
}
