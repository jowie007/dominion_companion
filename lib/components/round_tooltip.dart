import 'package:flutter/material.dart';

class RoundTooltip extends StatefulWidget {
  const RoundTooltip({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  State<RoundTooltip> createState() => _RoundTooltipState();
}

class _RoundTooltipState extends State<RoundTooltip> {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.3,
      child: Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Colors.black,
        ),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
            Positioned(
              top: 2,
              left: 2,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 20),
                // Set your desired max width here
                child: Tooltip(
                  message: widget.title,
                  child: Icon(widget.icon),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
