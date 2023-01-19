import 'dart:developer';

import 'package:flutter/material.dart';

class RoundCheckbox extends StatefulWidget {
  const RoundCheckbox(
      {super.key, required this.onChanged, required this.value});

  final void Function(bool? value) onChanged;
  final bool? value;

  @override
  State<RoundCheckbox> createState() => _RoundCheckboxState();
}

class _RoundCheckboxState extends State<RoundCheckbox> {
  @override
  Widget build(BuildContext context) {
    // Dominion card size 91mm x 59mm
    return Transform.scale(
      scale: 1.3,
      child: Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Colors.black,
        ),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
              alignment: Alignment.topLeft,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage("assets/menu/main_scroll_crop.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: const SizedBox(
                width: 28,
                height: 28,
              ),
            ),
            Checkbox(
              // https://api.flutter.dev/flutter/material/Checkbox/tristate.html
              tristate: true,
              checkColor: Colors.black,
              activeColor: Colors.transparent,
              value: widget.value,
              shape: const CircleBorder(),
              onChanged: widget.onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
