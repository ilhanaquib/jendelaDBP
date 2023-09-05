// import 'package:flutter/material.dart';

// void main() async {
//   runApp(const MyWidget());
// }

// class MyWidget extends StatelessWidget {
//   const MyWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     int colorSwitch = 1;
//     Map<int, Color> colorMap = {
//       1: Colors.red,
//       2: Colors.green,
//       3: Colors.blue,
//       4: Colors.pink,
//       5: Colors.yellow
//     };
//     Color getCurrentColor() {
//       return colorMap[colorSwitch] ?? Colors.white;
//     }

//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Padding(
//             padding: EdgeInsets.all(88.0),
//             child: Column(
//               children: [
//                 ElevatedButton(
//                     onPressed: () {
//                       colorSwitch++;
//                       if (colorSwitch > colorMap.length) {
//                         colorSwitch = 1;
//                       }
//                     },
//                     child: const Text('click me')),
//                 Container(color: getCurrentColor())
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
