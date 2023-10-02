import 'package:flutter/material.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';

class SettingButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onPressed;

  const SettingButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    this.onPressed,
  }) : super(key: key);

  @override
  State<SettingButton> createState() => _SettingButtonState();
}

class _SettingButtonState extends State<SettingButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: widget.onPressed,
      style: ButtonStyle(
        side: MaterialStateProperty.all(BorderSide(
          color: widget.isSelected
              ? DbpColor().jendelaGreen
              : const Color.fromARGB(255, 248, 248, 248),
        )),
        backgroundColor: MaterialStateProperty.all(
          widget.isSelected
              ? DbpColor().jendelaGreen
              : const Color.fromARGB(255, 248, 248, 248),
        ),
        foregroundColor: MaterialStateProperty.all(
          widget.isSelected ? Colors.white : const Color(0xFF7B7B7B),
        ),
      ),
      child: Row(
        children: [
          Icon(
            widget.icon,
            color: widget.isSelected ? Colors.white : const Color(0xFF7B7B7B),
          ),
          const SizedBox(width: 10),
          Text(
            widget.label,
            style: TextStyle(
              color: widget.isSelected ? Colors.white : const Color(0xFF7B7B7B),
            ),
          ),
        ],
      ),
    );
  }
}

