import 'dart:async';
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
  List<UniqueKey> keys = [];
  bool showLoadingIcon = true;
  bool cachedNotifier = false;
  bool disposed = false;
  int activeLoader = 0;

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

  void init() async {
    setState(() {
      decks = [];
      showLoadingIcon = true;
      cachedNotifier = settingService.notifier.value;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadExpansions();
      });
    });
  }

  loadExpansions() {
    setState(() {
      activeLoader = activeLoader + 1;
    });
    loadExpansionRecursive(SettingsService().getCachedSettings(), activeLoader);
  }

  loadExpansionRecursive(SettingsModel settingsModel, int loaderId) async {
    if (!disposed || loaderId != activeLoader) {
      DeckService()
          .getDeckByPosition(decks.length,
              sortAsc: settingsModel.sortAsc, sortKey: settingsModel.sortKey)
          .then(
            (element) => {
              if (!disposed || loaderId != activeLoader)
                {
                  setState(
                    () {
                      if (element != null) {
                        decks.add(element);
                        keys.add(UniqueKey());
                        loadExpansionRecursive(settingsModel, loaderId);
                      } else {
                        showLoadingIcon = false;
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
                                key: keys[decks.indexOf(e)],
                                deckModel: e,
                                onRouteLeave: () {
                                  setState(() {
                                    disposed = true;
                                    decks = [];
                                  });
                                },
                                onChange: () {
                                  if (widget.onChange != null) {
                                    widget.onChange!();
                                  }
                                  setState(() {
                                    disposed = false;
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
