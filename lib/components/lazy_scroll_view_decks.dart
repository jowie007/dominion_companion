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

  @override
  initState() {
    super.initState();
    init();
  }

  void init() {
    decks = [];
    showLoadingIcon = true;
    cachedNotifier = settingService.notifier.value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadExpansionRecursive();
    });
  }

  loadExpansionRecursive() async {
    SettingsModel settingsModel = SettingsService().getCachedSettings();
    log(settingsModel.sortKey + settingsModel.sortAsc.toString());
    DeckService()
        .getDeckByPosition(decks.length,
            sortAsc: settingsModel.sortAsc, sortKey: settingsModel.sortKey)
        .then(
          (element) => {
            setState(
              () {
                if (element != null) {
                  setState(() {
                    decks.add(element);
                  });
                  loadExpansionRecursive();
                } else {
                  setState(() {
                    showLoadingIcon = false;
                  });
                }
              },
            ),
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: settingService.notifier,
      builder: (BuildContext context, bool val, Widget? child) {
        if(cachedNotifier != settingService.notifier.value) {
          cachedNotifier = settingService.notifier.value;
          init();
        }
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 64),
            child: Column(
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
