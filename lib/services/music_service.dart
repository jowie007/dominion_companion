import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';

// https://pub.dev/packages/assets_audio_player
class MusicService {
  static final MusicService _musicService = MusicService._internal();

  AssetsAudioPlayer? assetsAudioPlayer;

  final Audio audio = Audio(
    "assets/audio/soundtrack/dominion.wav",
    metas: Metas(
      title: "Julias' Dominion Companion",
      image: const MetasImage.file("assets/artwork/cover/cover.png"),
    ),
  );

  factory MusicService() {
    return _musicService;
  }

  MusicService._internal();

  var isPlaying = false;

  ValueNotifier<bool> notifier = ValueNotifier(false);

  void init() {
    assetsAudioPlayer = AssetsAudioPlayer();
    assetsAudioPlayer!.open(
      audio,
      showNotification: true,
      loopMode: LoopMode.single,
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      notificationSettings: NotificationSettings(
          nextEnabled: false,
          prevEnabled: false,
          seekBarEnabled: false,
          stopEnabled: true,
          playPauseEnabled: true,
          customStopAction: (_) {
            assetsAudioPlayer!.stop();
            assetsAudioPlayer = null;
          },
          customPlayPauseAction: (_) {
            togglePlaying();
          }),
    );
  }

  void togglePlaying() {
    if (assetsAudioPlayer == null) {
      init();
    }
    assetsAudioPlayer!.playOrPause();
    isPlaying = !isPlaying;
    notifier.value = !notifier.value;
  }

  String getTooltip() {
    return isPlaying ? "Musik stoppen" : "Musik starten";
  }
}
