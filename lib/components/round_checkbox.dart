import 'dart:developer';

import 'package:flutter/material.dart';

class RoundCheckbox extends StatefulWidget {
  const RoundCheckbox(
      {super.key, required this.callback, required this.selected});

  final void Function(bool? value) callback;
  final bool? selected;

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
          unselectedWidgetColor: Colors.white,
        ),
        child: Checkbox(
          // https://api.flutter.dev/flutter/material/Checkbox/tristate.html
          tristate: true,
          checkColor: Colors.white,
          activeColor: Colors.red,
          value: widget.selected,
          shape: const CircleBorder(),
          onChanged: (bool? value) {
            if(widget.selected == null) {
              widget.callback(false);
              log("${false}H");
            } else {
              widget.callback(widget.selected!);
              log("${value}B");
            }
          },
        ),
      ),
    );
  }
}
