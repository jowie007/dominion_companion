import '../../../model/deck/deck_model.dart';

class DeckDBModel {
  late String name;
  late List<String> cardIds;
  late DateTime creationDate;
  late DateTime? editDate;
  late int? rating;

  DeckDBModel(
      this.name, this.cardIds, this.creationDate, this.editDate, this.rating);

  DeckDBModel.fromDB(Map<String, dynamic> dbData) {
    name = dbData['name'].toString();
    cardIds = dbData['cardIds'].split(',');
    creationDate = DateTime.fromMicrosecondsSinceEpoch(dbData['creationDate']);
    editDate = dbData['editDate'] != null
        ? DateTime.fromMicrosecondsSinceEpoch(dbData['editDate'])
        : null;
    editDate = dbData['editDate'] != null
        ? DateTime.fromMicrosecondsSinceEpoch(dbData['editDate'])
        : null;
    rating = dbData['rating'];
  }

  DeckDBModel.fromModel(DeckModel model) {
    name = model.name;
    cardIds = model.cards.map((card) => card.id).toList();
    creationDate = model.creationDate;
    editDate = model.editDate;
    rating = model.rating;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'cardIds': cardIds.join(','),
        'creationDate': creationDate.millisecondsSinceEpoch,
        'editDate': editDate != null ? editDate!.millisecondsSinceEpoch : null,
        'rating': rating,
      };
}
