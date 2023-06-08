import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({Key? key, required this.text, required this.callback})
      : super(key: key);

  final String text;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    // Dominion card size 91mm x 59mm
    return SizedBox(
      height: 80,
      child: MaterialButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: callback,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Image(
              image: AssetImage('assets/menu/longer_button.png'),
            ),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
