import 'package:dominion_companion/components/custom_alert_dialog.dart';
import 'package:dominion_companion/components/expansion_expandable.dart';
import 'package:dominion_companion/model/expansion/expansion_model.dart';
import 'package:dominion_companion/services/expansion_service.dart';
import 'package:dominion_companion/services/selected_card_service.dart';
import 'package:flutter/material.dart';

class LazyScrollViewExpansions extends StatefulWidget {
  const LazyScrollViewExpansions({super.key, required this.onChanged});

  final void Function() onChanged;

  @override
  State<LazyScrollViewExpansions> createState() =>
      _LazyScrollViewExpansionsState();
}

class _LazyScrollViewExpansionsState extends State<LazyScrollViewExpansions> {
  final ExpansionService _expansionService = ExpansionService();
  final SelectedCardService _selectedCardService = SelectedCardService();
  List<ExpansionModel> expansions = [];
  bool showLoadingIcon = true;
  bool disposed = false;
  int runCount = 0;
  int deselectAllCount = 0;
  int batchSize = 5;
  ValueNotifier<int> resetSelectionNotifier = ValueNotifier<int>(0);

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      runCount++;
      loadExpansionBatch(runCount);
    });
  }

  @override
  void dispose() {
    super.dispose();
    disposed = true;
  }

  void reloadData() {
    setState(() {
      runCount++;
      expansions = [];
      showLoadingIcon = true;
      loadExpansionBatch(runCount);
    });
  }

  loadExpansionBatch(int currentRunCount) async {
    if (!disposed && runCount == currentRunCount) {
      List<ExpansionModel> batch =
          await _expansionService.getActiveExpansionsByRange(
              expansions.length, expansions.length + batchSize);
      if (!disposed && runCount == currentRunCount) {
        setState(() {
          expansions.addAll(batch);
          showLoadingIcon = batch.length == batchSize;
        });
      }
    }
  }

  Future<dynamic> showConfirmationDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: "Auswahl zurücksetzen",
          message: "Möchtest du die ausgewählten Karten wirklich zurücksetzen?",
          cancelText: "Abbrechen",
          confirmText: "Ja",
          onConfirm: () async => {
            await SelectedCardService().deleteSelectedCards(),
            setState(() {
              deselectAllCount++;
              widget.onChanged();
            }),
            resetSelectionNotifier.value++,
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 64),
      itemCount: expansions.length + (showLoadingIcon ? 2 : 1),
      // Add 1 for the button
      itemBuilder: (context, index) {
        if (index == 0) {
          // The first item is the button
          return Container(
            padding: const EdgeInsets.fromLTRB(40, 16, 40, 0),
            child: ElevatedButton(
              onPressed: () {
                if (_selectedCardService.selectedCardIds.isNotEmpty) {
                  showConfirmationDialog(context);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, foregroundColor: Colors.white),
              child: const Text("Auswahl zurücksetzen"),
            ),
          );
        } else if (index <= expansions.length) {
          // The next items are the expansions
          return ExpansionExpandable(
            expansion: expansions[index - 1], // Subtract 1 for the button
            onChanged: () => {widget.onChanged()},
            onReload: reloadData,
            resetSelectionNotifier: resetSelectionNotifier,
          );
        } else {
          // The last item is the loading indicator
          return FutureBuilder(
            future: showLoadingIcon && expansions.isNotEmpty
                ? loadExpansionBatch(runCount)
                : null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(0, expansions.isEmpty ? 16 : 0,
                      0, expansions.isEmpty ? 16 : 0),
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else {
                // Rebuild the ListView when the future completes
                return Container();
              }
            },
          );
        }
      },
    );
  }
}
