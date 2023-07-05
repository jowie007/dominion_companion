import 'dart:developer';

import 'package:dominion_companion/services/audio_service.dart';
import 'package:flutter/material.dart';

class FloatingActionButtonCoin extends StatefulWidget {
  const FloatingActionButtonCoin(
      {super.key,
      required this.icon,
      required this.tooltip,
      required this.onPressed});

  final IconData icon;
  final String tooltip;
  final void Function() onPressed;

  @override
  State<FloatingActionButtonCoin> createState() =>
      _FloatingActionButtonCoinState();
}

class _FloatingActionButtonCoinState extends State<FloatingActionButtonCoin> {
  AudioService audioService = AudioService();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: () => {widget.onPressed(), audioService.playAudioCoin()},
      tooltip: widget.tooltip,
      backgroundColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/cards/other/coin.png"),
                fit: BoxFit.cover),
          ),
          child: Icon(widget.icon, color: Colors.black) // button text
          ),
    );
  }
}
