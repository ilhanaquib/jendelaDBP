import 'package:flutter/material.dart';
class CarouselTitle extends StatelessWidget {
  final String? title;
  final Function()? seeAllOnTap;
  final String? seeAllText;
  final Color? color;
  CarouselTitle({this.title, this.seeAllOnTap, this.seeAllText, this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const Divider(
            height: 20.0,
            color: Colors.transparent,
            thickness: 5.0,
            endIndent: 250.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 250,
                child: Text(
                  this.title ?? '',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: this.seeAllOnTap,
                  child: Text(
                    this.seeAllText ?? 'See All',
                    style: const TextStyle(color: Color.fromARGB(255, 123, 123, 123)),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
