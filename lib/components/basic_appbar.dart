import 'package:flutter/material.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BasicAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    // Dominion card size 91mm x 59mm

    return AppBar(
      title: Text(title,
          style: const TextStyle(
              fontFamily: 'TrajanPro')),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/menu/main_scroll_top_crop.png'),
                fit: BoxFit.fill)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
