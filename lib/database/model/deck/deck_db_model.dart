class DeckDBModel {
  final String id;
  final String name;
  final List<String> cardIds;

  const DeckDBModel({required this.id, required this.name, required this.cardIds});

  factory DeckDBModel.fromDatabase(String id, String name, String cardIds) =>
      DeckDBModel(id: id, name: name, cardIds: cardIds.split(','));

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'cardIds': "1"};
}
