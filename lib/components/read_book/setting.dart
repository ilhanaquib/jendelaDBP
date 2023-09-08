import 'package:flutter/material.dart';

import 'package:jendela_dbp/components/read_book/appearanceButton.dart';
import 'package:jendela_dbp/components/read_book/fontButton.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 40, left: 20),
            child: Row(
              children: [
                Text(
                  'Display Setting',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Appearance',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color.fromARGB(255, 248, 248, 248)),
                    child: const AppearanceButtons()),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Font Size',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color.fromARGB(255, 248, 248, 248)),
                    child: const FontButtons())
              ],
            ),
          ),
        ],
      ),
    );
  }
}
