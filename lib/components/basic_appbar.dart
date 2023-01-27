import 'package:dominion_comanion/services/music_service.dart';
import 'package:flutter/material.dart';

class BasicAppBar extends StatefulWidget implements PreferredSizeWidget {
  const BasicAppBar({super.key, required this.title});

  final String title;

  @override
  State<BasicAppBar> createState() => _BasicAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _BasicAppBarState extends State<BasicAppBar> {
  @override
  Widget build(BuildContext context) {
    final musicService = MusicService();

    return AppBar(
      title:
          Text(widget.title, style: const TextStyle(fontFamily: 'TrajanPro')),
      centerTitle: true,
      actions: <Widget>[
        ValueListenableBuilder(
          valueListenable: musicService.notifier,
          builder: (BuildContext context, bool val, Widget? child) {
            return IconButton(
              icon: Icon(
                musicService.isPlaying ? Icons.music_note : Icons.music_off,
                color: Colors.white,
              ),
              onPressed: () {
                musicService.togglePlaying();
              },
            );
          },
        ),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/menu/main_scroll_top_crop.png'),
                fit: BoxFit.fill)),
      ),
    );
  }
}
