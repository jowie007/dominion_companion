import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:flutter/material.dart';

class CreateDeckButton extends StatelessWidget {
  const CreateDeckButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 72,
      icon: const Icon(Icons.add),
      onPressed: () {
        // ...
      },
    );
  }
}
