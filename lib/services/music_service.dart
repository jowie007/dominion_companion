import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';

// TODO Enable looping
// TODO Enable notification
// https://pub.dev/packages/assets_audio_player
class MusicService {
  static final MusicService _musicService = MusicService._internal();

  final assetsAudioPlayer = AssetsAudioPlayer();
  final Audio audio = Audio("assets/audio/dominion.wav");

  bool initialized = false;

  factory MusicService() {
    return _musicService;
  }

  MusicService._internal();

  var isPlaying = false;

  ValueNotifier<bool> notifier = ValueNotifier(false);

  void init() {
    assetsAudioPlayer.open(audio);
    initialized = true;
  }

  void togglePlaying() {
    if (!initialized) {
      init();
    }
    assetsAudioPlayer.playOrPause();
    isPlaying = !isPlaying;
    notifier.value = !notifier.value;
  }

  String getTooltip() {
    return isPlaying ? "Musik stoppen" : "Musik starten";
  }
}
