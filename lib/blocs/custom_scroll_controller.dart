import 'package:flutter/material.dart';
import 'package:jendela_dbp/components/audiobook/paragraph.dart';

class CustomScrollControllerWidget extends StatefulWidget {
  @override
  _CustomScrollControllerWidgetState createState() =>
      _CustomScrollControllerWidgetState();
}

class _CustomScrollControllerWidgetState
    extends State<CustomScrollControllerWidget> {
  ScrollController _scrollController = ScrollController();
  double boxHeight = 0;
  double middlePosition = 0;
  double paragraphHeight =
      30; // Replace with the actual height of each paragraph
  int paragraphCount = 10; // Replace with the actual number of paragraphs

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    setState(() {
      boxHeight = _scrollController.position.viewportDimension;
      middlePosition = boxHeight / 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: paragraphCount,
      itemExtent: paragraphHeight,
      itemBuilder: (context, index) {
        double paragraphPosition = index * paragraphHeight;
        double difference = (paragraphPosition - middlePosition).abs();
        double opacity = 1.0 - (difference / (boxHeight / 2));
        Color textColor = Colors.grey.withOpacity(opacity);

        return CustomParagraph(
          text: 'Your paragraph text here',
          textColor: textColor,
        );
      },
    );
  }
}

class CustomParagraph extends StatelessWidget {
  final String text;
  final Color textColor;

  const CustomParagraph({required this.text, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: textColor),
    );
  }
}
