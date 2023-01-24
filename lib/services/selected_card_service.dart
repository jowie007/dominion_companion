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

  void insertSelectedCardIdIntoDB(String cardId) {
    if (!selectedCardIds.contains(cardId)) {
      selectedCardIds.add(cardId);
      _selectedCardDatabase.insertSelectedCardId(cardId);
    }
  }

  void deleteSelectedCardIdIntoDB(String cardId) {
    if (selectedCardIds.contains(cardId)) {
      selectedCardIds.remove(cardId);
      _selectedCardDatabase.deleteSelectedCardId(cardId);
    }
  }

  void toggleSelectedCardIdDB(String cardId) {
    if (selectedCardIds.contains(cardId)) {
      selectedCardIds.remove(cardId);
      _selectedCardDatabase.insertSelectedCardId(cardId);
    } else {
      selectedCardIds.add(cardId);
      _selectedCardDatabase.deleteSelectedCardId(cardId);
    }
  }
}
