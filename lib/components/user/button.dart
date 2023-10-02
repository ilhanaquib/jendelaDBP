import 'package:flutter/material.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';

class Button extends StatelessWidget {
  const Button({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 170),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side:  BorderSide(
                        color: DbpColor().jendelaOrange,),
                    backgroundColor: DbpColor().jendelaOrange,
                    minimumSize: const Size.fromHeight(40)),
                child: const Text('Save'),
              ),
              const SizedBox(height: 10,),
              OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                      foregroundColor: DbpColor().jendelaGray,
                      side: const BorderSide(
                          color: Color.fromARGB(255, 206, 206, 206)),
                      backgroundColor: const Color.fromARGB(255, 206, 206, 206),
                      minimumSize: const Size.fromHeight(40)),
                  child: const Text('Cancel')),
            ],
          ),
        ),
      ),
    );
  }
}
