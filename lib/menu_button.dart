import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    // Dominion card size 91mm x 59mm
    return MaterialButton(
      onPressed: () {  },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const FractionallySizedBox(
              heightFactor: 0.4,
              child: Image(
                image: AssetImage('assets/menu/copper_button.jpg'),
              ),
            ),
          ),
          Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: 'TrajanPro', fontSize: 30, color: Colors.white)),
        ],
      ),
    );
  }
}
