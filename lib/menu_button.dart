import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton(
      {Key? key,
      required this.text,
      this.type = "copper",
      required this.navigationPage})
      : super(key: key);

  final String text;
  final String type;
  final StatelessWidget navigationPage;

  @override
  Widget build(BuildContext context) {
    // Dominion card size 91mm x 59mm
    return SizedBox(
      height: 80,
      child: MaterialButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => navigationPage),
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image(
              image: AssetImage('assets/menu/${type}_button.png'),
            ),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: 'TrajanPro',
                    fontSize: 24,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
