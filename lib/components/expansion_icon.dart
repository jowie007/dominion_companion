import 'package:flutter/material.dart';

class ExpansionIcon extends StatefulWidget {
  const ExpansionIcon({super.key, required this.icon});

  final String icon;

  @override
  State<ExpansionIcon> createState() => _ExpansionIconState();
}

class _ExpansionIconState extends State<ExpansionIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      alignment: Alignment.topLeft,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/artwork/icon/${widget.icon}.png"),
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }
}
