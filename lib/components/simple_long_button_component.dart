import 'package:dominion_companion/services/audio_service.dart';
import 'package:flutter/material.dart';

class SimpleLongButtonComponent extends StatelessWidget {
  const SimpleLongButtonComponent({super.key, required this.text, required this.callback});

  final String text;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    final audioService = AudioService();
    return SizedBox(
      height: 70,
      child: MaterialButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () => {callback(), audioService.playAudioButton()},
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Image(
              image: AssetImage('assets/menu/simple_long_button.png'),
            ),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
