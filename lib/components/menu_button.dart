import 'package:dominion_companion/services/audio_service.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({Key? key, required this.text, required this.callback})
      : super(key: key);

  final String text;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    final audioService = AudioService();
    return SizedBox(
      height: 80,
      child: MaterialButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () => {callback(), audioService.playAudioButton()},
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
