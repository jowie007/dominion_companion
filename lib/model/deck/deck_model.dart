class Deck {
  final String id;
  final String name;
  final List<String> cardIds;

  const Deck({required this.id, required this.name, required this.cardIds});

  factory Deck.fromDatabase(String id, String name, String cardIds) =>
      Deck(id: id, name: name, cardIds: cardIds.split(','));

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'cardIds': "1"};
}
