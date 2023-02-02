class DeckDBModel {
  late String name;
  late List<String> cardIds;

  DeckDBModel(this.name, this.cardIds);

  DeckDBModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    cardIds = json['cardIds'].split(',');
  }

  DeckDBModel.fromModel(DeckDBModel model) {
    name = model.name;
    cardIds = model.cardIds;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'cardIds': cardIds.join(','),
      };
}
