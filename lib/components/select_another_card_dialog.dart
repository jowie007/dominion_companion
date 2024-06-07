import 'package:dominion_companion/components/basic_dropdown.dart';
import 'package:dominion_companion/model/card/card_model.dart';
import 'package:dominion_companion/model/expansion/expansion_model.dart';
import 'package:dominion_companion/services/expansion_service.dart';
import 'package:flutter/material.dart';

class SelectAnotherCardDialog extends StatefulWidget {
  const SelectAnotherCardDialog({
    Key? key,
    required this.onSaved,
  }) : super(key: key);

  final void Function(String selectedCard) onSaved;

  @override
  State<SelectAnotherCardDialog> createState() =>
      _SelectAnotherCardDialogState();
}

class _SelectAnotherCardDialogState extends State<SelectAnotherCardDialog> {
  Key key = UniqueKey();
  String selectedExpansion = '';
  String selectedCard = '';
  Map<String, String> availableExpansions = {};
  Map<String, String> availableCards = {};

  @override
  void initState() {
    super.initState();
    loadExpansions();
    loadAvailableCards(selectedExpansion);
  }

  Future<void> loadExpansions() async {
    List<ExpansionModel> allExpansions =
        await ExpansionService().getAllExpansions();
    updateExpansions(allExpansions);
  }

  void updateExpansions(List<ExpansionModel> allExpansions) {
    setState(() {
      availableExpansions = {
        for (var expansion in allExpansions)
          expansion.id: expansion.getFullName()
      };
      if (availableExpansions.isNotEmpty) {
        selectedExpansion = availableExpansions.keys.first;
        loadAvailableCards(selectedExpansion);
      }
      key = UniqueKey();
    });
  }

  void loadAvailableCards(String expansionId) async {
    ExpansionModel? expansion =
        await ExpansionService().getExpansionById(expansionId);
    List<CardModel> availableCardsList =
        expansion != null ? expansion.getVisibleCards() : [];
    updateAvailableCards(availableCardsList);
  }

  void updateAvailableCards(List<CardModel> availableCardsList) {
    availableCardsList.sort((a, b) => a.name.compareTo(b.name));
    setState(() {
      availableCards = {
        for (var card in availableCardsList) card.id: card.name
      };
      if (availableCards.isNotEmpty) {
        selectedCard = availableCards.keys.first;
      }
      key = UniqueKey();
    });
  }

  void changeSelectedExpansion(String? newExpansion) {
    if (newExpansion == null) return;
    setState(() {
      selectedExpansion = newExpansion;
      loadAvailableCards(newExpansion);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: availableExpansions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('Karte hinzufügen'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 10),
                      child: BasicDropdown(
                        key: key,
                        selected: selectedExpansion,
                        available: availableExpansions,
                        onChanged: changeSelectedExpansion,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 28),
                      child: BasicDropdown(
                        key: key,
                        selected: selectedCard,
                        available: availableCards,
                        onChanged: (newCard) =>
                            {setState(() => selectedCard = newCard!)},
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Abbrechen'),
                        ),
                        TextButton(
                          onPressed: () {
                            widget.onSaved(selectedCard);
                            Navigator.pop(context);
                          },
                          child: const Text('Speichern'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
