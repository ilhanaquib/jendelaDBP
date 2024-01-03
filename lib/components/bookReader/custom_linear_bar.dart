import 'package:flutter/material.dart';
import 'package:jendela_dbp/controllers/dbp_color.dart';

class CustomLinearProgressBar extends StatelessWidget {
  final double value;
  final Function(double) onTap;

  const CustomLinearProgressBar({
    super.key,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        double tapPositionX = details.localPosition.dx;
        double progressBarWidth = renderBox.size.width;
        double percentage = tapPositionX / progressBarWidth;

        onTap(percentage);
      },
      child: LinearProgressIndicator(
        value: value,
        valueColor: AlwaysStoppedAnimation<Color>(DbpColor().jendelaOrange),
        minHeight: 8,
      ),
    );
  }
}
