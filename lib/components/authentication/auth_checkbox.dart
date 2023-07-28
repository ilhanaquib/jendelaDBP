import 'package:flutter/material.dart';

class AuthCheckbox extends StatefulWidget {
  const AuthCheckbox({super.key});

  @override
  State<AuthCheckbox> createState() => _AuthCheckboxState();
}

class _AuthCheckboxState extends State<AuthCheckbox> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return const Color.fromARGB(255, 235, 127, 35);
      }
      return const Color.fromARGB(255, 185, 185, 185);
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}
