import 'dart:developer';

import 'package:flutter/material.dart';

class BasicInfoBar extends StatefulWidget {
  const BasicInfoBar({super.key, required this.text});

  final String text;

  @override
  State<BasicInfoBar> createState() => _BasicInfoBarState();
}

class _BasicInfoBarState extends State<BasicInfoBar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(80),
        bottomRight: Radius.circular(80),
      ),
      child: Container(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
        width: MediaQuery.of(context).size.width,
        height: 32.0,
        child: Center(
          child: Text(
            widget.text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
