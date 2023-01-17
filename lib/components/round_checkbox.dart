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
          unselectedWidgetColor: Colors.white,
        ),
        child: Checkbox(
          // https://api.flutter.dev/flutter/material/Checkbox/tristate.html
          tristate: true,
          checkColor: Colors.white,
          activeColor: Colors.red,
          value: widget.value,
          shape: const CircleBorder(),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
