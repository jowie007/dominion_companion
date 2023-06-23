import 'package:flutter/material.dart';

class ButtonPlusMinus extends StatefulWidget {
  const ButtonPlusMinus(
      {super.key,
      required this.text,
      required this.onMinus,
      required this.onPlus});

  final String text;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  State<ButtonPlusMinus> createState() => _ButtonPlusMinusState();
}

class _ButtonPlusMinusState extends State<ButtonPlusMinus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 268,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(120),
        image: const DecorationImage(
            image: AssetImage('assets/menu/simple_long_button.png'),
            fit: BoxFit.none),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.8),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(1, 2), // changes position of shadow
          ),
        ],
      ),
      height: 42.0,
      child: Row(
        children: [
          MaterialButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: widget.onMinus,
            child: const Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.remove, color: Colors.white),
              ],
            ),
          ),
          Text(widget.text,
              style: const TextStyle(fontSize: 18, color: Colors.white)),
          MaterialButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: widget.onPlus,
            child: const Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.add, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
