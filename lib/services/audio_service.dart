import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dominion_companion/services/settings_service.dart';
import 'package:flutter/cupertino.dart';

// https://pub.dev/packages/assets_audio_player
class AudioService {
  static final AudioService _audioService = AudioService._internal();

  SettingsService settingsService = SettingsService();

  final Audio audioButton = Audio("assets/audio/soundeffects/button.wav");
  final Audio audioClose = Audio("assets/audio/soundeffects/close.wav");
  final Audio audioCoin = Audio("assets/audio/soundeffects/coin.wav");
  final Audio audioOpen = Audio("assets/audio/soundeffects/open.wav");
  final Audio audioShuffle = Audio("assets/audio/soundeffects/shuffle.wav");
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  factory AudioService() {
    return _audioService;
  }

  AudioService._internal();

  var isPlaying = false;

  ValueNotifier<bool> notifier = ValueNotifier(false);

  void playAudioButton() {
    if (settingsService.getCachedSettings().playAudio) {
      assetsAudioPlayer.open(
        audioButton,
        showNotification: false,
        loopMode: LoopMode.none,
      );
    }
  }

  void playAudioClose() {
    if (settingsService.getCachedSettings().playAudio) {
      assetsAudioPlayer.open(
        audioClose,
        showNotification: false,
        loopMode: LoopMode.none,
      );
    }
  }

  void playAudioCoin() {
    if (settingsService.getCachedSettings().playAudio) {
      assetsAudioPlayer.open(
        audioCoin,
        showNotification: false,
        loopMode: LoopMode.none,
      );
    }
  }

  void playAudioOpen() {
    if (settingsService.getCachedSettings().playAudio) {
      assetsAudioPlayer.open(
        audioOpen,
        showNotification: false,
        loopMode: LoopMode.none,
      );
    }
  }

  void playAudioShuffle() {
    if (settingsService.getCachedSettings().playAudio) {
      assetsAudioPlayer.open(
        audioShuffle,
        showNotification: false,
        loopMode: LoopMode.single,
      );
    }
  }

  void stopPlaying() {
    assetsAudioPlayer.pause();
    assetsAudioPlayer = AssetsAudioPlayer();
  }
}
