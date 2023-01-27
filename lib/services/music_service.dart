import 'package:flutter/cupertino.dart';

class MusicService {
  static final MusicService _musicService = MusicService._internal();

  factory MusicService() {
    return _musicService;
  }

  MusicService._internal();

  var isPlaying = false;

  ValueNotifier<bool> notifier = ValueNotifier(false);

  void togglePlaying() {
    isPlaying = !isPlaying;
    notifier.value = !notifier.value;
  }

  String getTooltip() {
    return isPlaying ? "Musik stoppen" : "Musik starten";
  }
}