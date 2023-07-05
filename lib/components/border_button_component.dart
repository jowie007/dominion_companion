import 'package:dominion_companion/services/audio_service.dart';
import 'package:flutter/material.dart';

class BorderButtonComponent extends StatelessWidget {
  const BorderButtonComponent(
      {Key? key,
      this.color = 'red',
      this.width = 80,
      required this.icon,
      required this.onClick})
      : super(key: key);

  final String? color;
  final double? width;
  final IconData icon;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    final audioService = AudioService();
    return MaterialButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: () => {onClick(), audioService.playAudioButton()},
      child: Container(
        width: width,
        height: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/menu/${color}_button.png'),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: width! * 0.2,
            ),
            Icon(
              icon,
              size: width! * 0.5,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
