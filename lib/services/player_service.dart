import 'package:flutter/cupertino.dart';

class PlayerService {
  static final PlayerService _playerService = PlayerService._internal();

  var players = 2;
  final minPlayers = 2;
  final maxPlayers = 6;

  factory PlayerService() {
    return _playerService;
  }

  PlayerService._internal();

  ValueNotifier<bool> notifier = ValueNotifier(false);

  void addPlayer() {
    if (players < maxPlayers) {
      players++;
      notifier.value = !notifier.value;
    }
  }

  void subtractPlayer() {
    if (players > minPlayers) {
      players--;
      notifier.value = !notifier.value;
    }
  }
}
