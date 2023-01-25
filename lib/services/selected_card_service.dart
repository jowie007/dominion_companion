import 'dart:developer';

import 'package:dominion_comanion/database/selectedCardsDatabase.dart';

class SelectedCardService {
  late SelectedCardDatabase _selectedCardDatabase;
  late List<String> selectedCardIds;

  SelectedCardService() {
    _selectedCardDatabase = SelectedCardDatabase();
    selectedCardIds = [];
  }

  Future<void> initializeSelectedCardIds() async {
    selectedCardIds = await _selectedCardDatabase.getSelectedCardIdList();
  }

  void insertSelectedCardIdsIntoDB(List<String> cardIds) {
    for (var cardId in cardIds) {
      insertSelectedCardIdIntoDB(cardId);
    }
  }

  void deleteSelectedCardIdsFromDB(List<String> cardIds) {
    for (var cardId in cardIds) {
      deleteSelectedCardIdFromDB(cardId);
    }
  }

  void insertSelectedCardIdIntoDB(String cardId) {
    if (!selectedCardIds.contains(cardId)) {
      selectedCardIds.add(cardId);
      _selectedCardDatabase.insertSelectedCardId(cardId);
    }
  }

  void deleteSelectedCardIdFromDB(String cardId) {
    if (selectedCardIds.contains(cardId)) {
      selectedCardIds.remove(cardId);
      _selectedCardDatabase.deleteSelectedCardId(cardId);
    }
  }

  void toggleSelectedCardIdDB(String cardId) {
    if (selectedCardIds.contains(cardId)) {
      selectedCardIds.remove(cardId);
      _selectedCardDatabase.deleteSelectedCardId(cardId);
    } else {
      selectedCardIds.add(cardId);
      _selectedCardDatabase.insertSelectedCardId(cardId);
    }
  }

  void toggleSelectedExpansion(List<String> cardsInExpansion) {
    if (isExpansionSelected(cardsInExpansion) == false) {
      insertSelectedCardIdsIntoDB(cardsInExpansion);
    } else {
      deleteSelectedCardIdsFromDB(cardsInExpansion);
    }
  }

  bool? isExpansionSelected(List<String> cardsInExpansion) {
    var containsOne = false;
    var containsAll = true;
    for (var cardId in cardsInExpansion) {
      if (selectedCardIds.contains(cardId)) {
        containsOne = true;
      } else {
        containsAll = false;
      }
    }
    return containsAll
        ? true
        : containsOne
            ? null
            : false;
  }
}
