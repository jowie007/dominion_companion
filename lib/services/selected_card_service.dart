
import 'package:dominion_companion/database/selected_cards_database.dart';
import 'package:dominion_companion/model/expansion/expansion_model.dart';
import 'package:dominion_companion/services/deck_service.dart';
import 'package:dominion_companion/services/expansion_service.dart';

class SelectedCardService {
  final DeckService deckService = DeckService();
  final SelectedCardDatabase _selectedCardDatabase = SelectedCardDatabase();
  late List<String> selectedCardIds = [];
  late bool modifyDeck = false;

  static final SelectedCardService _selectedCardService =
      SelectedCardService._internal();

  factory SelectedCardService() {
    return _selectedCardService;
  }

  SelectedCardService._internal();

  Future<void> initializeSelectedCardIds({int? deckId}) async {
    if (deckId != null) {
      selectedCardIds = await deckService.getCardIdsByDeckId(deckId) ?? [];
      modifyDeck = true;
    } else {
      selectedCardIds = await _selectedCardDatabase.getSelectedCardIdList();
      modifyDeck = false;
    }
  }

  void addSelectedCardIds(List<String> cardIds) {
    for (var cardId in cardIds) {
      addSelectedCardId(cardId);
    }
  }

  Future<void> deleteSelectedCards() async {
    if (!modifyDeck) {
      await _selectedCardDatabase.deleteSelectedCards();
    }
  }

  void deleteSelectedCardIds(List<String> cardIds) {
    for (var cardId in cardIds) {
      deleteSelectedCardId(cardId);
    }
  }

  void addSelectedCardId(String cardId) {
    if (!selectedCardIds.contains(cardId)) {
      selectedCardIds.add(cardId);
      if (!modifyDeck) {
        _selectedCardDatabase.insertSelectedCardId(cardId);
      }
    }
  }

  void deleteSelectedCardId(String cardId) {
    if (selectedCardIds.contains(cardId)) {
      selectedCardIds.remove(cardId);
      if (!modifyDeck) {
        _selectedCardDatabase.deleteSelectedCardId(cardId);
      }
    }
  }

  void toggleSelectedCardId(String cardId) {
    if (selectedCardIds.contains(cardId)) {
      selectedCardIds.remove(cardId);
      if (!modifyDeck) {
        _selectedCardDatabase.deleteSelectedCardId(cardId);
      }
    } else {
      selectedCardIds.add(cardId);
      if (!modifyDeck) {
        _selectedCardDatabase.insertSelectedCardId(cardId);
      }
    }
  }

  void toggleSelectedExpansion(ExpansionModel expansionModel) {
    if (isExpansionSelected(expansionModel) == false) {
      addSelectedCardIds(expansionModel.getVisibleCardsIds());
    } else {
      deleteSelectedCardIds(expansionModel.getCardIds());
    }
  }

  bool? isExpansionSelected(ExpansionModel expansionModel) {
    var cardsInExpansion = expansionModel.getVisibleCardsIds();
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

  Future<bool> hasOtherVersionOfExpansionSelectedCards(
      ExpansionModel expansion) async {
    List<ExpansionModel> expansionsWithSamePrefix = await ExpansionService()
        .getExpansionsWithSamePrefixExcludeItself(expansion.id);
    for (var expansionWithSamePrefix in expansionsWithSamePrefix) {
      if (isExpansionSelected(expansionWithSamePrefix) != false) {
        return true;
      }
    }
    return false;
  }
}
