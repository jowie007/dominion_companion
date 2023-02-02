import 'package:dominion_comanion/database/model/deck/deck_db_model.dart';
import 'package:dominion_comanion/model/card/card_model.dart';

class DeckModel {
  late String name;
  late List<CardModel> cards;

  DeckModel(this.name, this.cards);

  DeckModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    cards = json['cardIds'].split(',');
  }
}
