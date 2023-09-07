import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  ErrorCard({this.message, this.errorCode = 500});
  final String? message;
  final int? errorCode;

  Widget build(BuildContext context) {
    return Center(child: Text(this.message ?? ''));
  }
}
