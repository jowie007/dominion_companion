
import 'package:flutter/material.dart';

class BasicInfoBarBottom extends StatefulWidget {
  const BasicInfoBarBottom({super.key, required this.text});

  final String text;

  @override
  State<BasicInfoBarBottom> createState() => _BasicInfoBarBottomState();
}

class _BasicInfoBarBottomState extends State<BasicInfoBarBottom> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      /*borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(80),
        topRight: Radius.circular(80),
      ),*/
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/menu/main_scroll_top_crop.png'),
              fit: BoxFit.fill),
        ),
        width: MediaQuery.of(context).size.width,
        height: 42.0,
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
