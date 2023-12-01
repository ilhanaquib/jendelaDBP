import 'package:flutter/material.dart';

Widget bukaPDFButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 40,
        padding: const EdgeInsets.all(2),
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

Widget bukaAudioButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 40,
        padding: const EdgeInsets.all(2),
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

Widget downloadPDFButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 40,
        padding: const EdgeInsets.all(2),
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

Widget downloadAudioButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 40,
        padding: const EdgeInsets.all(2),
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

Widget audioButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 40,
        padding: const EdgeInsets.all(2),
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

Widget bukaEPUBButton() {
  return SizedBox(
    width: 80,
    child: Center(
      child: ElevatedButton(
        child: const Text('Baca'),
        onPressed: () {},
      ),
    ),
  );
}

Widget downloadEPUBButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 40,
        padding: const EdgeInsets.all(2),
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
