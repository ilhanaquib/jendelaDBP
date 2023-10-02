import 'package:flutter/material.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';

class CarouselTitle extends StatelessWidget {
  final String? title;
  final Function()? seeAllOnTap;
  final String? seeAllText;
  final Color? color;
  const CarouselTitle(
      {super.key, this.title, this.seeAllOnTap, this.seeAllText, this.color});
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
              SizedBox(
                width: 250,
                child: Text(
                  title ?? '',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: seeAllOnTap,
                  child: Text(
                    seeAllText ?? 'See All',
                    style: TextStyle(
                      color: DbpColor().jendelaGray,
                    ),
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
