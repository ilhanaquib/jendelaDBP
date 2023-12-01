import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({super.key, this.message, this.errorCode = 500});
  final String? message;
  final int? errorCode;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message ?? ''));
  }
}
