import 'package:dominion_comanion/components/button_plus_minus.dart';
import 'package:dominion_comanion/services/player_service.dart';
import 'package:flutter/material.dart';

class ButtonPlayerCount extends StatefulWidget {
  const ButtonPlayerCount({super.key});

  @override
  State<ButtonPlayerCount> createState() => _ButtonPlayerCountState();
}

class _ButtonPlayerCountState extends State<ButtonPlayerCount> {
  final playerService = PlayerService();

  @override
  Widget build(BuildContext context) {
    return ButtonPlusMinus(
      text: "${playerService.players} Spielende",
      onMinus: () => setState(() {
        playerService.subtractPlayer();
      }),
      onPlus: () => setState(() {
        playerService.addPlayer();
      }),
    );
  }
}