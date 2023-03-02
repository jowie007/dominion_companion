import 'dart:convert';
import 'dart:developer';

import 'package:dominion_comanion/database/model/content/content_db_model.dart';
import 'package:dominion_comanion/database/model/end/end_db_model.dart';
import 'package:dominion_comanion/database/model/hand/hand_db_model.dart';
import 'package:dominion_comanion/model/end/end_model.dart';
import 'package:dominion_comanion/model/hand/hand_model.dart';

import '../../../model/deck/deck_model.dart';

class DeckDBModel {
  late String name;
  late List<String> cardIds;
  /*late ContentDBModel? content;
  late HandDBModel hand;
  late EndDBModel end;*/

  DeckDBModel(this.name, this.cardIds);

  DeckDBModel.fromDB(Map<String, dynamic> dbData) {
    name = dbData['name'].toString();
    cardIds = dbData['cardIds'].split(',');
    /*content = dbData['content'] != ''
        ? ContentDBModel.fromDB(jsonDecode(dbData['content']))
        : null;
    hand = HandDBModel.fromDB(jsonDecode(dbData['hand']));
    end = EndDBModel.fromDB(jsonDecode(dbData['end']));*/
  }

  DeckDBModel.fromModel(DeckModel model) {
    name = model.name;
    cardIds = model.cards.map((card) => card.id).toList();
    /*content =
        model.content != null ? ContentDBModel.fromModel(model.content!) : null;
    hand = HandDBModel.fromModel(model.hand);
    end = EndDBModel.fromModel(model.end);*/
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'cardIds': cardIds.join(','),
        /*'content': content != null
            ? jsonEncode(content?.toJson())
                .replaceAll("true", "1")
                .replaceAll("false", "0")
            : '',
        'hand': jsonEncode(hand.toJson())
            .replaceAll("true", "1")
            .replaceAll("false", "0"),
        'end': jsonEncode(end.toJson())
            .replaceAll("true", "1")
            .replaceAll("false", "0"),*/
      };
}
