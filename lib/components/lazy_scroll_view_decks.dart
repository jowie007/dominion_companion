import 'dart:developer';

import 'package:dominion_companion/components/deck_expandable.dart';
import 'package:dominion_companion/model/deck/deck_model.dart';
import 'package:dominion_companion/model/settings/settings_model.dart';
import 'package:dominion_companion/services/deck_service.dart';
import 'package:dominion_companion/services/settings_service.dart';
import 'package:flutter/material.dart';

class LazyScrollViewDecks extends StatefulWidget {
  const LazyScrollViewDecks({super.key, this.onChange});

  final void Function()? onChange;

  @override
  State<LazyScrollViewDecks> createState() => _LazyScrollViewDecksState();
}

class _LazyScrollViewDecksState extends State<LazyScrollViewDecks> {
  SettingsService settingService = SettingsService();
  List<DeckModel> decks = [];
  bool showLoadingIcon = true;
  bool cachedNotifier = false;
  bool disposed = false;

  @override
  initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    disposed = true;
  }

  void init() {
    decks = [];
    showLoadingIcon = true;
    cachedNotifier = settingService.notifier.value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadExpansions();
    });
  }

  loadExpansions() {
    loadExpansionRecursive(SettingsService().getCachedSettings());
  }

  loadExpansionRecursive(SettingsModel settingsModel) async {
    if (!disposed) {
      DeckService()
          .getDeckByPosition(decks.length,
              sortAsc: settingsModel.sortAsc, sortKey: settingsModel.sortKey)
          .then(
            (element) => {
              if (!disposed)
                {
                  setState(
                    () {
                      if (element != null) {
                        setState(() {
                          decks.add(element);
                        });
                        loadExpansionRecursive(settingsModel);
                      } else {
                        setState(() {
                          showLoadingIcon = false;
                        });
                      }
                    },
                  ),
                },
            },
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: settingService.notifier,
      builder: (BuildContext context, bool val, Widget? child) {
        if (cachedNotifier != settingService.notifier.value) {
          cachedNotifier = settingService.notifier.value;
          init();
        }
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 64),
            child: !showLoadingIcon && decks.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text("Keine Decks gefunden..."),
                  )
                : Column(
                    children: [
                      ...decks
                          .map<Widget>((e) => DeckExpandable(
                                deckModel: e,
                                onChange: () {
                                  if (widget.onChange != null) {
                                    widget.onChange!();
                                  }
                                  setState(() {
                                    init();
                                  });
                                },
                              ))
                          .toList(),
                      showLoadingIcon
                          ? const Center(child: CircularProgressIndicator())
                          : Container()
                    ],
                  ),
          ),
        );
      },
    );
  }
}
