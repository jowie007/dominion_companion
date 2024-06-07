import '../../../model/deck/deck_model.dart';

class DeckDBModel {
  late int? id;
  late String name;
  late String color;
  late String description;
  late List<String> cardIds;
  late DateTime creationDate;
  late DateTime? editDate;
  late int? rating;

  DeckDBModel(this.id, this.name, this.color, this.description, this.cardIds, this.creationDate,
      this.editDate, this.rating);

  DeckDBModel.fromDB(Map<String, dynamic> dbData) {
    id = dbData['id'];
    name = dbData['name'].toString();
    color = dbData['color'].toString();
    description = dbData['description'].toString();
    cardIds = dbData['cardIds'].toString().trim() != ""
        ? dbData['cardIds'].split(',')
        : [];
    creationDate = DateTime.fromMillisecondsSinceEpoch(dbData['creationDate']);
    editDate = dbData['editDate'] != null
        ? DateTime.fromMillisecondsSinceEpoch(dbData['editDate'])
        : null;
    rating = dbData['rating'];
  }

  DeckDBModel.fromModel(DeckModel model) {
    id = model.id;
    name = model.name;
    color = model.color;
    description = model.description;
    cardIds = model.cards.map((card) => card.id).toList();
    creationDate = model.creationDate;
    editDate = model.editDate;
    rating = model.rating;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'color': color,
        'description': description,
        'cardIds': cardIds.join(','),
        'creationDate': creationDate.millisecondsSinceEpoch,
        'editDate': editDate != null ? editDate!.millisecondsSinceEpoch : null,
        'rating': rating,
      };

  Map<String, dynamic> toDBJson() => {
        'id': id,
        'name': name,
        'color': color,
        'description': description,
        'cardIds': cardIds.join(','),
        'creationDate': creationDate.millisecondsSinceEpoch,
        'editDate': editDate != null ? editDate!.millisecondsSinceEpoch : null,
        'rating': rating,
      };
}
