import 'package:dominion_comanion/router/routes.dart' as route;
import 'package:flutter/material.dart';

class CreateDeckButton extends StatelessWidget {
  const CreateDeckButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 72,
      icon: const Icon(Icons.add),
      onPressed: () {
        Navigator.pushNamed(context, route.createDeckPage);
      },
    );
  }
}
