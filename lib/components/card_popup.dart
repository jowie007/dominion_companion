import 'dart:developer';

import 'package:dominion_comanion/components/coin_component.dart';
import 'package:dominion_comanion/components/round_checkbox.dart';
import 'package:dominion_comanion/components/expansion_icon.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/services/card_service.dart';
import 'package:dominion_comanion/services/player_service.dart';
import 'package:flutter/material.dart';

class CardPopup extends StatefulWidget {
  const CardPopup({
    super.key,
  });

  @override
  State<CardPopup> createState() => _CardPopupState();
}

class _CardPopupState extends State<CardPopup> {
  // https://stackoverflow.com/questions/70529682/create-pop-up-dialog-in-flutter
  // https://daily-dev-tips.com/posts/flutter-3d-pan-effect/

  Offset _offset = Offset.zero;

  updatePan(DragUpdateDetails details) {
    var tempOffset = _offset + details.delta;
    if (tempOffset.dx < 80 &&
        tempOffset.dx > -80 &&
        tempOffset.dy < 40 &&
        tempOffset.dy > -40) {
      _offset += details.delta;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // perspective
          ..rotateX(0.01 * _offset.dy) // changed
          ..rotateY(-0.01 * _offset.dx),
        alignment: FractionalOffset.center,
        child: GestureDetector(
          onPanUpdate: (details) => setState(() => updatePan(details)),
          onDoubleTap: () => setState(() => _offset = Offset.zero),
          child: const FractionallySizedBox(
            widthFactor: 0.7,
            heightFactor: 0.9,
            child: Image(image: AssetImage('assets/cards/full/torw.png')),
          ),
        ),
      ),
    );
  }
}