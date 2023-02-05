import '../../../model/deck/deck_model.dart';

class DeckDBModel {
  late String name;
  late List<String> cardIds;

  DeckDBModel(this.name, this.cardIds);

  DeckDBModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    cardIds = json['cardIds'].split(',');
  }

  DeckDBModel.fromModel(DeckModel model) {
    name = model.name;
    cardIds = model.cards.map((card) => card.id).toList();
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'cardIds': cardIds.join(','),
      };
}
