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

  void addPlayer() {
    if (players < maxPlayers) {
      players++;
    }
  }

  void subtractPlayer() {
    if (players > minPlayers) {
      players--;
    }
  }
}
