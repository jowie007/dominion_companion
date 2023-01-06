import 'package:flutter/material.dart';

class DominionCard extends StatelessWidget {
  const DominionCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Dominion card size 91mm x 59mm

    return SizedBox(
        width: 59 * 5,
        height: 91 * 5,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
            ),
            const Align(
              heightFactor: 1.6,
              alignment: Alignment.center,
              child: FractionallySizedBox(
                heightFactor: 0.4,
                child: Image(
                  image: AssetImage('assets/cards/images/base/laboratory.webp'),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.center,
              child: FractionallySizedBox(
                heightFactor: 0.96,
                child: Image(
                  image: AssetImage('assets/cards/types/action.webp'),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: const FractionallySizedBox(
                  heightFactor: 0.12,
                  child: Image(
                    image: AssetImage('assets/cards/other/coin.png'),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 16.0),
                child: const Text("3",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Minion', fontSize: 46)),
              ),
            ),
            const Align(
              heightFactor: 1.6,
              alignment: Alignment.center,
              child: Text("Keller",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'TrajanPro', fontSize: 30)),
            ),
          ],
        ));
  }
}
