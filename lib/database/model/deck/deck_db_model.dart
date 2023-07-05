import '../../../model/deck/deck_model.dart';

class DeckDBModel {
  late int? id;
  late String name;
  late List<String> cardIds;
  late String? image;
  late DateTime creationDate;
  late DateTime? editDate;
  late int? rating;

  DeckDBModel(this.id, this.name, this.image, this.cardIds, this.creationDate,
      this.editDate, this.rating);

  DeckDBModel.fromDB(Map<String, dynamic> dbData) {
    id = dbData['id'];
    name = dbData['name'].toString();
    cardIds = dbData['cardIds'].toString().trim() != ""
        ? dbData['cardIds'].split(',')
        : [];
    image = dbData['image'];
    creationDate = DateTime.fromMillisecondsSinceEpoch(dbData['creationDate']);
    editDate = dbData['editDate'] != null
        ? DateTime.fromMillisecondsSinceEpoch(dbData['editDate'])
        : null;
    rating = dbData['rating'];
  }

  DeckDBModel.fromModel(DeckModel model) {
    id = model.id;
    name = model.name;
    cardIds = model.cards.map((card) => card.id).toList();
    image = null;
    creationDate = model.creationDate;
    editDate = model.editDate;
    rating = model.rating;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cardIds': cardIds.join(','),
        'creationDate': creationDate.millisecondsSinceEpoch,
        'editDate': editDate != null ? editDate!.millisecondsSinceEpoch : null,
        'rating': rating,
      };

  Map<String, dynamic> toJsonWithImage() => {
        'id': id,
        'name': name,
        'cardIds': cardIds.join(','),
        'image': image,
        'creationDate': creationDate.millisecondsSinceEpoch,
        'editDate': editDate != null ? editDate!.millisecondsSinceEpoch : null,
        'rating': rating,
      };

  Map<String, dynamic> toDBJson() => {
        'id': id,
        'name': name,
        'cardIds': cardIds.join(','),
        'creationDate': creationDate.millisecondsSinceEpoch,
        'editDate': editDate != null ? editDate!.millisecondsSinceEpoch : null,
        'rating': rating,
      };
}
